# frozen_string_literal: true

require "decidim/newsletter_agenda/engine"

module Decidim
  # This namespace holds the logic of the `decidim-newsletter_agenda` module.
  module NewsletterAgenda
    include ActiveSupport::Configurable

    # The default background color for the newsletter agenda.
    # leave it empty (nil) to use the configured organization's main color.
    # this color can be overriden in the newsletter template builder.
    # hex color code with #, e.g. "#39747f".
    # If nil, it uses the one defined in the config accessor "themes" for the theme
    config_accessor :default_background_color do
      nil
    end

    # The default font color over background for the newsletter agenda.
    # leave it empty (nil) to use the one defined in the config accessor "themes" for the theme
    config_accessor :default_font_color_over_bg do
      nil
    end

    config_accessor :default_link_color do
      nil
    end

    # The default address text for the newsletter agenda.
    # leave it empty (nil) to use the one defined in the config accessor "themes" for the theme
    config_accessor :default_address_text do
      nil
    end

    # The social handlers for the newsletter agenda. If defined in the organization will try to reuse them
    # leave it empty (nil) to use the one defined in the config accessor "themes" for the theme
    config_accessor :social_handlers do
      nil
    end

    # Defines additional handlers for the newsletter template builder.
    # Available themes: :canodrom, :capitalitat
    config_accessor :themes do
      {
        canodrom: {
          default_background_color: "#7636D2",
          default_font_color_over_bg: "#FFFFFF",
          default_link_color: "#7636D2",
          default_address_text: "<b>Canòdrom</b><br>" \
                                "<b>Ateneu d'Innovació Digital i Democràtica</b><br>" \
                                "C/Concepción Arenal 165<br>08027 Barcelona <a href='https://canodrom.barcelona'>canodrom.barcelona</a><br>" \
                                "<a href='mailto:hola@canodrom.barcelona'>hola@canodrom.barcelona</a>",
          social_handlers: {
            twitter: nil,
            instagram: nil,
            facebook: nil,
            youtube: nil,
            github: nil,
            mastodon: "https://mastodont.cat/@canodrombcn",
            telegram: "https://t.me/canodrombcn",
            peertube: nil
          }
        },
        capitalitat: {
          default_background_color: "#524F9F",
          default_font_color_over_bg: "#FFFFFF",
          default_link_color: "#524F9F",
          default_address_text: "<b>European Capital of Democracy</b><br>" \
                                "C/Concepció Arenal 165<br>08027 Barcelona <a href='https://capitalofdemocracy.barcelona'>capitalofdemocracy.barcelona</a><br>" \
                                "<a href='mailto:rgpd@pemb.cat'>rgpd@pemb.cat</a>",
          social_handlers: {
            twitter: nil,
            youtube: nil
          }
        }
      }
    end

    # To define the default first day for the agenda ranges.
    # This is the next monday:
    def self.next_first_day
      Date.current - Date.current.wday + 8
    end

    # To define the default last day for the agenda ranges.
    # This is the next sunday after the next monday:
    def self.next_last_day
      Date.current - Date.current.wday + 14
    end
  end
end
