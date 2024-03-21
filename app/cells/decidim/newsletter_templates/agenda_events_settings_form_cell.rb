# frozen_string_literal: true

module Decidim
  module NewsletterTemplates
    class AgendaEventsSettingsFormCell < BaseSettingsFormCell
      include ThemeMethods

      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def settings
        @settings ||= form.object.settings.tap do |settings|
          settings[:link_color] ||= default_link_color
          settings[:background_color] ||= default_background_color
          settings[:font_color_over_bg] ||= default_font_color_over_bg
          settings[:body_title].tap do |hash|
            I18n.available_locales.each do |locale|
              hash[locale] = I18n.t("decidim.newsletter_templates.agenda_events.body_title_preview", locale:) if hash[locale].nil?
            end
          end
          settings[:body_subtitle].tap do |hash|
            I18n.available_locales.each do |locale|
              hash[locale] = DateRangeFormatter.format(Decidim::NewsletterAgenda.next_first_day, Decidim::NewsletterAgenda.next_last_day) if hash[locale].nil?
            end
          end
          settings[:body_final_text].tap do |hash|
            I18n.available_locales.each do |locale|
              hash[locale] = I18n.t("decidim.newsletter_templates.agenda_events.body_final_text_preview", locale:) if hash[locale].nil?
            end
          end
          settings[:footer_title].tap do |hash|
            I18n.available_locales.each do |locale|
              hash[locale] = I18n.t("decidim.newsletter_templates.agenda_events.footer_title_preview", locale:) if hash[locale].nil?
            end
          end
          settings[:footer_social_links_title].tap do |hash|
            I18n.available_locales.each do |locale|
              hash[locale] = I18n.t("decidim.newsletter_templates.agenda_events.footer_social_links_title_preview", locale:) if hash[locale].nil?
            end
          end

          settings[:footer_address_text] = default_address_text if settings[:footer_address_text].blank?

          # social handlers
          social_handlers&.each do |handler|
            settings["#{handler}_handler"] ||= organization_handler_attributes["#{handler}_handler"]
          end

          # boxes
          (1..4).each do |num|
            settings["body_box_link_text_#{num}"].tap do |hash|
              I18n.available_locales.each do |locale|
                hash[locale] = I18n.t("decidim.newsletter_templates.agenda_events.body_box_link_text_preview", locale:) if hash[locale].nil?
              end
            end
          end

          (1..3).each do |num|
            settings["footer_box_link_text_#{num}"].tap do |hash|
              I18n.available_locales.each do |locale|
                hash[locale] = I18n.t("decidim.newsletter_templates.agenda_events.footer_box_link_text_preview", locale:) if hash[locale].nil?
              end
            end
          end
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity
    end
  end
end
