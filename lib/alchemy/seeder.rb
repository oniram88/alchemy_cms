require "#{File.dirname(__FILE__)}/shell"

module Alchemy
  class Seeder

    extend Shell

    class << self

      # This seed builds the necessary page structure for alchemy in your database.
      # Run the alchemy:db:seed rake task to seed your database.
      def seed!
        create_default_site
        create_root_page
      end

    private

      def desc(message)
        puts "\n#{message}"
        puts "#{'-' * message.length}\n"
      end

    protected

      def create_default_site
        desc "Creating default site"
        if Alchemy::Site.count == 0
          site = Alchemy::Site.new(
            name: 'Default Site',
            host: '*'
          )
          if Alchemy::Language.any?
            site.languages = Alchemy::Language.all
          end
          site.save!
          log "Created default site with default language."
        else
          log "Default site was already present.", :skip
        end
      end

      def create_root_page
        desc "Creating root page"
        root = Alchemy::Page.find_or_initialize_by_name(
          :name => 'Root',
          :do_not_sweep => true
        )
        if root.new_record?
          if root.save!
            log "Created page #{root.name}."
          end
        else
          log "Page #{root.name} was already present.", :skip
        end
      end

    end

  end
end
