# frozen_string_literal: true

require "date_range_formatter"

module Decidim
  module NewsletterAgenda
    # This is the engine that runs on the public interface of decidim-newsletter_agenda.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::NewsletterAgenda

      # The newsletter has some bugs when previewing and locales
      initializer "decidim_reporting_proposals.overrides", after: "decidim.action_controller" do
        config.to_prepare do
          Decidim::Admin::NewslettersController.include(Decidim::NewsletterAgenda::Admin::FixNewsletterPreviewLocales)
          Decidim::Admin::NewsletterTemplatesController.include(Decidim::NewsletterAgenda::Admin::FixNewsletterPreviewLocales)
        end
      end

      initializer "decidim-newsletter_agenda.newsletter_templates" do
        Decidim::NewsletterAgenda.themes.each do |theme, properties|
          Decidim.content_blocks.register(:newsletter_template, "#{theme}_agenda_events") do |content_block|
            content_block.cell = "decidim/newsletter_templates/agenda_events"
            content_block.settings_form_cell = "decidim/newsletter_templates/agenda_events_settings_form"
            content_block.public_name_key = "decidim.newsletter_templates.agenda_events.#{theme}_name"

            content_block.images = [
              {
                name: :main_image,
                uploader: "Decidim::NewsletterTemplateImageUploader"
              }
            ]

            (1..4).each do |i|
              content_block.images << {
                name: :"body_box_image_#{i}",
                uploader: "Decidim::NewsletterTemplateImageUploader",
                preview: -> { ActionController::Base.helpers.asset_pack_path("media/images/placeholder.jpg") }
              }
            end

            (1..3).each do |i|
              content_block.images << {
                name: :"footer_box_image_#{i}",
                uploader: "Decidim::NewsletterTemplateImageUploader",
                preview: -> { ActionController::Base.helpers.asset_pack_path("media/images/placeholder.jpg") }
              }
            end

            content_block.settings do |settings|
              settings.attribute(
                :link_color,
                type: :text,
                preview: -> { Decidim::NewsletterAgenda.default_link_color || properties[:default_link_color] || "#39747f" }
              )
              settings.attribute(
                :background_color,
                type: :text,
                preview: -> { Decidim::NewsletterAgenda.default_background_color || properties[:default_background_color] || "#39747f" }
              )
              settings.attribute(
                :font_color_over_bg,
                type: :text,
                preview: -> { Decidim::NewsletterAgenda.default_font_color_over_bg || properties[:default_font_color_over_bg] || "#FFFFFF" }
              )
              settings.attribute(
                :intro_title,
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.intro_title_preview") }
              )
              settings.attribute(
                :intro_text,
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.intro_text_preview") }
              )
              settings.attribute(
                :intro_link_text,
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.intro_link_text_preview") }
              )
              settings.attribute(
                :intro_link_url,
                type: :text,
                preview: -> { "https://example.com" }
              )
              settings.attribute(
                :body_title,
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.body_title_preview") }
              )
              settings.attribute(
                :body_subtitle,
                type: :text,
                translated: true,
                preview: -> { DateRangeFormatter.format(Decidim::NewsletterAgenda.next_first_day, Decidim::NewsletterAgenda.next_last_day) }
              )
              settings.attribute(
                :boxes_number,
                type: :integer,
                preview: -> { 4 }
              )
              (1..4).each do |i|
                settings.attribute(
                  "body_box_title_#{i}",
                  type: :text,
                  translated: true,
                  preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.body_box_title_preview") }
                )
                settings.attribute(
                  "body_box_date_time_#{i}",
                  type: :text,
                  translated: true,
                  preview: -> { DateRangeFormatter.format(Decidim::NewsletterAgenda.next_first_day - 14 + i, Decidim::NewsletterAgenda.next_last_day - 15 + i) }
                )
                settings.attribute(
                  "body_box_description_#{i}",
                  type: :text,
                  translated: true,
                  preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.body_box_description_preview") }
                )
                settings.attribute(
                  "body_box_link_text_#{i}",
                  type: :text,
                  translated: true,
                  preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.body_box_link_text_preview") }
                )
                settings.attribute(
                  "body_box_link_url_#{i}",
                  type: :text,
                  translated: true,
                  preview: -> { "https://decidim.org" }
                )
              end
              settings.attribute(
                :body_final_text,
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.body_final_text_preview") }
              )
              settings.attribute(
                :footer_title,
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.footer_title_preview") }
              )
              (1..3).each do |i|
                settings.attribute(
                  "footer_box_date_time_#{i}",
                  type: :text,
                  translated: true,
                  preview: -> { DateRangeFormatter.format(Decidim::NewsletterAgenda.next_first_day - 14 + i, Decidim::NewsletterAgenda.next_last_day - 15 + i) }
                )
                settings.attribute(
                  "footer_box_title_#{i}",
                  type: :text,
                  translated: true,
                  preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.footer_box_title_preview") }
                )
                settings.attribute(
                  "footer_box_description_#{i}",
                  type: :text,
                  translated: true,
                  preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.footer_box_description_preview") }
                )
                settings.attribute(
                  "footer_box_link_text_#{i}",
                  type: :text,
                  translated: true,
                  preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.footer_box_link_text_preview") }
                )
                settings.attribute(
                  "footer_box_link_url_#{i}",
                  type: :text,
                  translated: true,
                  preview: -> { "https://decidim.org" }
                )
              end
              settings.attribute(
                :footer_address_text,
                type: :text,
                translated: false,
                preview: -> { NewsletterAgenda.default_address_text || properties[:default_address_text] }
              )
              settings.attribute(
                :footer_social_links_title,
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.footer_social_links_title_preview") }
              )
              settings.attribute(
                :footer_additional_text,
                type: :text,
                translated: true,
                preview: -> { I18n.t("decidim.newsletter_templates.agenda_events.footer_additional_text_preview") }
              )
              (Decidim::NewsletterAgenda.social_handlers || properties[:social_handlers])&.each do |handler, default|
                settings.attribute(
                  "#{handler}_handler",
                  type: :text,
                  translated: false,
                  preview: -> { default || "my-#{handler}" }
                )
              end
            end

            content_block.default!
          end
        end
      end

      initializer "decidim-newsletter_agenda.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::NewsletterAgenda::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::NewsletterAgenda::Engine.root}/app/views") # for partials
      end

      initializer "decidim-newsletter_agenda.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
