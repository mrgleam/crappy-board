import besom.*
import besom.api.hcloud
import hcloud.inputs.*

@main def main: Unit = Pulumi.run {
  val warning = log.warn("Nothing's here yet, it's waiting for you to write some code!")

  Stack(warning)
}