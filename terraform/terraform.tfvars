region = "eu-central-1"
vpc_cidr = "10.0.0.0/16"
public_cidrs = [
        "10.0.1.0/24",
        "10.0.2.0/24",
        "10.0.3.0/24"
]
private_cidrs = [
        "10.0.4.0/24",
        "10.0.5.0/24",
        "10.0.6.0/24"
]

instance_type = "t2.micro"
instance_count = 3
