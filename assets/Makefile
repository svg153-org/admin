.PHONY: watch
watch:
	docker run --rm -ti -v $(shell pwd):/ws -w /ws oscarberg/plantuml-watcher \
		--draw-on-add \
		--recursive