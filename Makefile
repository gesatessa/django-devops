# Makefile

.PHONY: createsuperuser

createsuperuser:
	docker compose run --rm app sh -c "python manage.py createsuperuser"
