variable "apps" {
  description = "Map of applications to deploy"
  type = map(object({
    replicas       = number
    container_port = number
    node_port      = number
  }))
  default = {
    app1 = {
      replicas       = 2
      container_port = 9898
      node_port      = 30001
    },
    app2 = {
      replicas       = 2
      container_port = 9898
      node_port      = 30002
    }
  }
}
