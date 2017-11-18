module Gnatt
	class Engine < ::Rails::Engine
		initializer 'gnatt.assets.precompile' do |app|
			app.config.assets.paths << root.join('assets', "javascripts").to_s
		end
	end
end
