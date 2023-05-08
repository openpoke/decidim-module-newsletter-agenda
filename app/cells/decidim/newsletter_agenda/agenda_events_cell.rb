# frozen_string_literal: true

require "cell/partial"

module Decidim
  module NewsletterAgenda
    class AgendaEventsCell < NewsletterTemplates::BaseCell
      include Decidim::LayoutHelper

      alias body show

      def show
        render :show
      end

      def has_image?(attribute)
        # for previews
        return true unless model&.id

        newsletter.template.images_container.send(attribute).attached?
      end

      def has_organization_logo?
        # for previews
        return true unless model&.id

        organization.logo.attached?
      end

      def has_footer_image?
        # for previews
        return true unless model&.id

        organization.official_img_footer.attached?
      end

      def image_url(attribute, options = { resize_to_fill: [306, 204] })
        return ActionController::Base.helpers.asset_pack_path("media/images/placeholder.jpg") unless model&.id

        representation_url(newsletter.template.images_container.send(attribute).variant(options))
      end

      def organization_logo_url
        if organization.logo.attached?
          representation_url(organization.logo.variant(resize_to_fit: [300, 80]))
        else
          ActionController::Base.helpers.asset_pack_path("media/images/decidim-logo.svg")
        end
      end

      def footer_image_url
        if organization.official_img_footer.attached?
          representation_url(organization.official_img_footer.variant(resize_to_fit: [500, 150]))
        else
          ActionController::Base.helpers.asset_pack_path("media/images/decidim-logo.svg")
        end
      end

      def translated_text_for(attribute)
        parse_interpolations(translated_attribute(model.settings.send(attribute)), recipient_user, newsletter.id)
      end

      def link_for(attribute)
        translated_attribute(model.settings.send(attribute))
      end

      def social_links
        links = []
        all_handler_attributes.each do |k, v|
          next if v.blank?

          network = k.split("_").first

          icon_path = asset_pack_url("media/images/#{network}.png", host_options)
          ico = tag.img(src: icon_path, alt: network.capitalize, class: "footer-social__icon", title: t("decidim.newsletter_agenda.agenda_events_settings_form.#{network}"))
          links << link_to(ico, network_url(v, network), target: "_blank", rel: "noopener", class: "footer-social__icon")
        end
        links
      end

      def background_image_top
        asset_pack_url("media/images/background_top.gif", host_options)
      end

      def background_image_bottom
        asset_pack_url("media/images/background_bottom.gif", host_options)
      end

      def background_color
        model.settings.background_color.presence || NewsletterAgenda.default_background_color
      end

      def font_color_over_bg
        model.settings.font_color_over_bg.presence || NewsletterAgenda.default_font_color_over_bg || "#FFFFFF"
      end

      private

      def representation_url(image)
        Rails.application.routes.url_helpers.rails_representation_url(image, host_options)
      end

      def host_options
        @host_options ||= begin
          options = Rails.configuration.action_mailer.default_url_options || {}
          options.merge(host: decidim.root_url(host: organization.host))
        end
      end

      def organization_handler_attributes
        organization.attributes.select { |key| key.to_s.include?("handler") }
      end

      def additional_handler_attributes
        additional_handler_attributes = {}
        Decidim::NewsletterAgenda.additional_social_handlers.each do |handler|
          key = "#{handler}_handler"
          additional_handler_attributes[key] = model.settings[key] if model.settings[key].present?
        end
        additional_handler_attributes
      end

      def all_handler_attributes
        organization_handler_attributes.merge(additional_handler_attributes)
      end

      def network_url(value, network)
        case network
        when "telegram"
          "https://#{network}.me/#{value}"
        when "mastodon"
          "https://#{network}.social/@#{value}"
        when "peertube"
          "https://#{network}.tv/c/#{value}"
        else
          "https://#{network}.com/#{value}"
        end
      end
    end
  end
end
