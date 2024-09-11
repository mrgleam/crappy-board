import besom._
import besom.api.hcloud
import hcloud.inputs._

@main def main: Unit = Pulumi.run {
  val locations = Vector("fsn1", "nbg1", "hel1")

  val sshPublicKey  = config.requireString("ssh_public_key")

  val sshPrivateKey  = config.requireString("ssh_private_key")

  val hcloudProvider = hcloud.Provider(
    "hcloud",
    hcloud.ProviderArgs(
      token = config.requireString("hcloud_token")
    )
  )

  val sshKey = hcloud.SshKey(
    "ssh-key",
    hcloud.SshKeyArgs(
      name = "ssh-key",
      publicKey = sshPublicKey
    ),
    opts(provider = hcloudProvider)
  )

  val serverPool = (1 to 3).map { i =>
    hcloud
      .Server(
        s"k3s-server-$i",
        hcloud.ServerArgs(
          serverType = "cx22",
          name = s"k3s-server-$i",
          image = "ubuntu-22.04",
          location = locations(i % locations.size),
          sshKeys = List(sshKey.name),
          publicNets = List(
            ServerPublicNetArgs(
              ipv4Enabled = true,
              ipv6Enabled = false
            )
          )
        ),
        opts(provider = hcloudProvider)
      )
  }.toVector

  val spawnNodes = serverPool.parSequence

  val nodeIps = serverPool.map(_.ipv4Address).parSequence

  val clusterName = "crappy-board-prod"

  val ghcrToken = config.requireString("github_docker_token").flatMap(_.toNonEmptyOutput)

  val k3s = K3S(
    clusterName,
    K3SArgs(
      clusterName = clusterName,
      serverIps = serverPool.map(_.ipv4Address),
      privateKey = sshPrivateKey,
      k3sVersion = "v1.31.0+k3s1",
      registryAuth = AuthArgs("ghcr.io", "mrgleam", ghcrToken)
    ),
    ComponentResourceOptions(
      deletedWith = serverPool.headOption.getOrElse(None)
    )
  )

  val writeKubeconfig = k3s.flatMap { k3s =>
    k3s.kubeconfig.map { kubeconfig =>
      os.write.over(os.pwd / "kubeconfig.conf", kubeconfig)
    }
  }

  Stack(spawnNodes, writeKubeconfig, k3s).exports(
    nodes = nodeIps,
    kubeconfigPath = (os.pwd / "kubeconfig.conf").toString,
  )
  
}