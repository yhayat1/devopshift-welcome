output "vm_public_ip" {
  value      = aws_instance.vm.public_ip
  depends_on = [null_resource.check_public_ip]
  description = "Public IP address of the VM"
}