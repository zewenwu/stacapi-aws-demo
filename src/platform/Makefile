# CI linting and formatting
lint:
	tflint --format default --recursive
	terraform fmt -check -recursive

format:
	terraform fmt -recursive .

# Terraform docs
update-terraform-docs-all:
	find ./terraform-components -type d -exec sh -c 'cd "{}" && make update-terraform-docs' \;