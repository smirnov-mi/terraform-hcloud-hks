# Template to use as a starting point for this module.

locals {
  hcloud_token = "cm8vWt0i53UtSTz7RyXpiYrLmal2XfGJxjkswpFXMuCzNkRrWqDfi4ahqVnju5yL"
}

output "kubeconfig" {
  value     = module.hks.kubeconfig
  sensitive = true
}

module "hks" {
  # For local testing
  # source = "../terraform-hks/"
  # If you want to use the latest main branch
  # source = "github.com/Stupremee/terraform-hks"

  source = "Stupremee/hks/hcloud"

  # Map of ssh keys that can be used to connect to the nodes.
  ssh_public_keys = {
    my-ssh-key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCyQLzGaS4kUL068R8xe56HEED1sjZfByqqUDvYU65/ZPMiiakjMqrEWLY60ITt/QTM8s9y7vpjMgbADeiwGUEZHvlIpBC/Zq6c/CLFn2L3qJcITKS2Km+f3LwVxYQvRvNYJjAhOtnJ/CZiaoc5VWcG+mtjAfdKjnmpTyu4c6JYh9zYCgJOMfAcYMUbxgBQR81cjN9VaiHo9btff0Bd+S5MNzGB5KBFDXA6Pg6fDie8T7bNjcAbuOpm7ig777yxWtTpZW1qFCWNAXqbWSScBx5EdAhdhuGvH6mdi1Z+0V5gDM4IORDCBhbYbwED0XlwYh4npF1c6QUJa7xNEPqfD8HNnCQvjcafuWW0OmPPYiTUt2sP/6r8AKu+9Vt2xObVjO2u8E2jt+M+cTgDrL1Q6GTT/Gs8Iwp+/wmvarl/Dintd0I1hWl7kfL4o750Jvyeg9QIlPq7LSfN7pkbnr8ubLXolcv5yjXo7U6PpkmbsJ6goD69g4xJp2budIrAO21ZDe3vAtkvlOekQ3ZqYPg7WGw939HiLuho4fB/0RLNzT7mCJYox3hIQHybNRGAPhOouXsV2/OQ702lUBJweZqHksrCI6sKUXwX5q50tw2Dl8MhsW9PtwH87ZsvsFeJ1eLmxFvT811mb3exujUdYDYyQxIn/DJwDvenftcFnMy6UJM/w== msc@dell-u24"
  }

  hcloud_token = local.hcloud_token

  # Common prefix for all resources
  # e.g. the servers will have the name hks-<agent pool name>-<idx>
  prefix = "hks"

  # If enabled, all created servers will perform a
  # system upgrade before starting the cluster. This will result
  # in a few minutes more of starting time, but should be enabled in production
  perform_system_update = false

  # The zone for the private Hetzner network that will be created.
  # Can be an of: eu-central, us-east, us-west
  network_zone = "eu-central"

  # Uncommenting this allows to customize the SSH port of the nodes.
  # ssh_port = 2222

  # Configure the single master server
  # Right now, multiple master nodes are not supported by this module
  master_node = {
    # The name of the master server
    name = "master"
    # The Hetzner server type
    # At least CPX21 is recommened, otherwise you will likely run into memory exhaustion
    server_type = "cx22"
    # The location of the server
    location = "fsn1"
  }

  # List of node pools to create as the agents for this cluster.
  agent_nodepools = [{
    # Give the node pool a name
    name = "small",
    # The type of servers for this pool
    server_type = "cx22",
    # The location
    location = "nbg1",
    # Amount of agents in this pool
    count = 1
    }, {
    name        = "big",
    server_type = "cx22",
    location    = "fsn1",
    count       = 0
  }]

  # In order for the NGINX Ingress server to work, a Hetzner load balancer must be created,
  # which can be configured here
  loadbalancer = {
    # Type/Size of the load balancer
    type     = "lb11"
    location = "fsn1"
  }

  # Configure the cert-manager instance that will be automatically deployed in the cluster.
  cert-manager = {
    # The mail that will be send to letsencrypt to create the SSL certificates
    email = "smirnov.mi@gmail.com"
  }
}
