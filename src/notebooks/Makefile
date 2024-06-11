conda-setup:
	conda create -n stacapi-notebook python=3.12 -y

conda-remove:
	conda remove -n stacapi-notebook --all -y

setup-reqs:
	pip install pip-tools
	pip-compile reqs/requirements.in
	pip-sync reqs/requirements.txt
    
install-kernel:
	python -m ipykernel install --user --name stacapi-notebook --display-name stacapi-notebook
