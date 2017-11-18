module Gantt
	class Engine < ::Rails::Engine
		initializer 'gantt.assets.precompile' do |app|
			app.config.assets.paths << root.join('assets', "javascripts").to_s
		end
	end
end
