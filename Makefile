project_dirs = lexical_shared lexical_plugin lexical_test
dialyzer_dirs = lexical_shared lexical_plugin

compile.all: compile.projects compile.umbrella

dialyzer.all: compile.all dialyzer.projects dialyzer.umbrella

test.all: test.projects test.umbrella

dialyzer.umbrella:
	mix dialyzer

dialyzer.projects:
	$(foreach dir, $(dialyzer_dirs), cd projects/$(dir) && mix dialyzer && cd ../..;)

test.umbrella:
	mix test

test.projects:
	cd projects
	$(foreach dir, $(project_dirs), cd projects/$(dir) && mix test && cd ../..;)

compile.umbrella: compile.projects
	mix deps.get
	mix compile --skip-umbrella-children

compile.projects:
	cd projects
	$(foreach dir, $(project_dirs), cd projects/$(dir) && mix deps.get && mix do clean, compile --warnings-as-errors && cd ../..;)

release.namespaced:
	mix do deps.clean --all, clean, deps.get 
	mix release lexical --overwrite 
	NAMESPACE=1 mix release lexical --overwrite