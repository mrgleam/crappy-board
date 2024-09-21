import besom.*

import besom.api.{kubernetes => k8s}
import k8s.core.v1.enums.*
import k8s.core.v1.inputs.*
import k8s.apps.v1.inputs.*
import k8s.meta.v1.inputs.*
import k8s.apps.v1.{Deployment, DeploymentArgs}
import k8s.core.v1.{Namespace, Service, ServiceArgs}
import k8s.networking.v1.{Ingress, IngressArgs}
import k8s.networking.v1.inputs.{
  IngressSpecArgs,
  IngressRuleArgs,
  HttpIngressRuleValueArgs,
  HttpIngressPathArgs,
  IngressBackendArgs,
  IngressServiceBackendArgs,
  ServiceBackendPortArgs
}
import k8s.helm.v4.inputs.*
import k8s.helm.v4.Chart
import k8s.helm.v4.ChartArgs

case class AppArgs private (
  name: Output[NonEmptyString],
  replicas: Output[Int],
  containerPort: Output[Int],
  servicePort: Output[Int],
  host: Output[NonEmptyString],
  secretKeyBase: Output[NonEmptyString]
)
object AppArgs:
  def apply(
    name: Input[NonEmptyString],
    replicas: Input[Int],
    containerPort: Input[Int],
    servicePort: Input[Int],
    host: Input[NonEmptyString],
    secretKeyBase: Input[NonEmptyString]
  )(using Context): AppArgs =
    new AppArgs(
      name.asOutput(),
      replicas.asOutput(),
      containerPort.asOutput(),
      servicePort.asOutput(),
      host.asOutput(),
      secretKeyBase.asOutput()
    )

case class PostgresArgs private (
  port: Output[Int]
)
object PostgresArgs:
  def apply(port: Input[Int])(using Context): PostgresArgs =
    new PostgresArgs(port.asOutput())

case class AppDeploymentArgs(
  postgresArgs: PostgresArgs,
  appArgs: AppArgs
)

case class AppDeployment(
  appUrl: Output[String]
)(using ComponentBase)
    extends ComponentResource
    derives RegistersOutputs
object AppDeployment:
  def apply(name: NonEmptyString, args: AppDeploymentArgs, resourceOpts: ComponentResourceOptions)(using Context): Output[AppDeployment] =
    component(name, "user:component:app-deployment", resourceOpts) {
      val labels = Map("app" -> name)

      val appNamespace = Namespace(name)

      val postgresPort = args.postgresArgs.port

      val containerPort = args.appArgs.containerPort
      val servicePort = args.appArgs.servicePort
      val ingressHost = args.appArgs.host
      val appReplicas = args.appArgs.replicas
      val appSecretKey = args.appArgs.secretKeyBase

      val postgresOperatorChart = Chart(
        "postgres-operator",
        ChartArgs(
          namespace = appNamespace.metadata.name,
          chart = "postgres-operator",
          version = "5.6.1",
          repositoryOpts = RepositoryOptsArgs(repo = "https://charts.crunchydata.com/charts/")
        )
      )

      val postgresCluster =
        k8s.yaml.v2.ConfigGroup(
          name = "postgres-cluster",
          k8s.yaml.v2.ConfigGroupArgs(
            yaml = p"""apiVersion: "postgres-operator.crunchydata.com/v1beta1"
                |kind: PostgresCluster
                |metadata:
                |  name: postgres-cluster
                |  labels:
                |    db: ${name}
                |spec:
                |  users:
                |    - name: crappy
                |      databases:
                |        - crappy
                |  postgresVersion: 16
                |  port: ${postgresPort}
                |  instances:
                |  - name: "pgha1"
                |    replicas: 2
                |    dataVolumeClaimSpec:
                |      accessModes:
                |        - "ReadWriteOnce"
                |      resources:
                |        requests:
                |          storage: 5Gi
                |  backups:
                |    pgbackrest:
                |      image: registry.developers.crunchydata.com/crunchydata/crunchy-pgbackrest:ubi8-2.51-1
                |      repos:
                |      - name: repo1
                |        volume:
                |          volumeClaimSpec:
                |            accessModes:
                |            - "ReadWriteOnce"
                |            resources:
                |              requests:
                |                storage: 5Gi
                |  """.stripMargin
          ),
          opts = opts(dependsOn = postgresOperatorChart)
        )

      val appDeployment =
        Deployment(
          name,
          DeploymentArgs(
            spec = DeploymentSpecArgs(
              selector = LabelSelectorArgs(matchLabels = labels),
              replicas = appReplicas,
              template = PodTemplateSpecArgs(
                metadata = ObjectMetaArgs(
                  name = p"$name-deployment",
                  labels = labels,
                  namespace = appNamespace.metadata.name
                ),
                spec = PodSpecArgs(
                  containers = ContainerArgs(
                    name = "app",
                    image = "ghcr.io/mrgleam/crappy-board:latest",
                    env = List(
                      EnvVarArgs(name = "SECRET_KEY_BASE", value = appSecretKey),
                      EnvVarArgs(
                        name = "PG_USER",
                        valueFrom = EnvVarSourceArgs(
                          secretKeyRef = SecretKeySelectorArgs(
                            name = "postgres-cluster-pguser-crappy",
                            key = "user"
                          )
                        )
                      ),
                      EnvVarArgs(
                        name = "PG_PASSWORD",
                        valueFrom = EnvVarSourceArgs(
                          secretKeyRef = SecretKeySelectorArgs(
                            name = "postgres-cluster-pguser-crappy",
                            key = "password"
                          )
                        )
                      ),
                      EnvVarArgs(
                        name = "PG_PORT",
                        valueFrom = EnvVarSourceArgs(
                          secretKeyRef = SecretKeySelectorArgs(
                            name = "postgres-cluster-pguser-crappy",
                            key = "port"
                          )
                        )
                      ),
                      EnvVarArgs(
                        name = "PG_HOST",
                        valueFrom = EnvVarSourceArgs(
                          secretKeyRef = SecretKeySelectorArgs(
                            name = "postgres-cluster-pguser-crappy",
                            key = "host"
                          )
                        )
                      ),
                      EnvVarArgs(
                        name = "PG_DB",
                        valueFrom = EnvVarSourceArgs(
                          secretKeyRef = SecretKeySelectorArgs(
                            name = "postgres-cluster-pguser-crappy",
                            key = "dbname"
                          )
                        )
                      )
                    ),
                    ports = List(
                      ContainerPortArgs(name = "http", containerPort = containerPort)
                    ),
                    readinessProbe = ProbeArgs(
                      httpGet = HttpGetActionArgs(
                        path = "/",
                        port = containerPort
                      ),
                      initialDelaySeconds = 10,
                      periodSeconds = 5
                    ),
                    livenessProbe = ProbeArgs(
                      httpGet = HttpGetActionArgs(
                        path = "/",
                        port = containerPort
                      ),
                      initialDelaySeconds = 10,
                      periodSeconds = 5
                    )
                  ) :: Nil
                )
              )
            ),
            metadata = ObjectMetaArgs(
              namespace = appNamespace.metadata.name
            )
          )
        )

      val appService =
        Service(
          s"$name-svc",
          ServiceArgs(
            spec = ServiceSpecArgs(
              selector = labels,
              ports = List(
                ServicePortArgs(name = "http", port = servicePort, targetPort = containerPort)
              ),
              `type` = ServiceSpecType.ClusterIP
            ),
            metadata = ObjectMetaArgs(
              namespace = appNamespace.metadata.name,
              labels = labels
            )
          ),
          opts(deleteBeforeReplace = true)
        )

      val appIngress =
        Ingress(
          s"$name-ingress",
          IngressArgs(
            spec = IngressSpecArgs(
              rules = List(
                IngressRuleArgs(
                  host = ingressHost,
                  http = HttpIngressRuleValueArgs(
                    paths = List(
                      HttpIngressPathArgs(
                        path = "/",
                        pathType = "Prefix",
                        backend = IngressBackendArgs(
                          service = IngressServiceBackendArgs(
                            name = appService.metadata.name.getOrElse(name),
                            port = ServiceBackendPortArgs(
                              number = servicePort
                            )
                          )
                        )
                      )
                    )
                  )
                )
              )
            ),
            metadata = ObjectMetaArgs(
              namespace = appNamespace.metadata.name,
              labels = labels,
              annotations = Map(
                "kubernetes.io/ingress.class" -> "traefik"
              )
            )
          )
        )

      // use all of the above and return final url
      val appUrl =
        for
          _   <- appNamespace
          _   <- postgresOperatorChart
          _   <- postgresCluster
          _   <- appDeployment
          _   <- appService
          _   <- appIngress
          url <- p"https://$ingressHost/"
        yield url

      AppDeployment(appUrl)
    }