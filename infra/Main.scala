import besom._
import besom.api.hcloud
import hcloud.inputs._

@main def main: Unit = Pulumi.run {
  val locations = Vector("fsn1", "nbg1", "hel1")

  val sshPublicKey  = config.requireString("ssh_public_key")

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

  Stack(spawnNodes).exports(
    nodes = nodeIps,
  )
  
}