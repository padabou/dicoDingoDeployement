############################################################
#
#
#       PLEASE TAKE CARE BEFORE CHANGE THIS CONTENT
#
#
############################################################

help: ## print this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m\t%s\n", $$1, $$2}'

# deploy equidico.fr nginx config file and restart nginx
deploy: ## deploy equidico.fr nginx config file and restart nginx
	sudo cp my-uuu.com /etc/nginx/sites-available/equidico.fr
	sudo /etc/init.d/nginx restart