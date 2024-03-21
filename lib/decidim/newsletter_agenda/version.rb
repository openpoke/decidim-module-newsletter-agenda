# frozen_string_literal: true

module Decidim
  module NewsletterAgenda
    VERSION = "1.1.0"
    DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.28-stable" }.freeze
    COMPAT_DECIDIM_VERSION = [">= 0.28.0", "< 0.29"].freeze
  end
end
