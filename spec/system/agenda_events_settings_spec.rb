# frozen_string_literal: true

require "spec_helper"

describe "Agenda events settings", type: :system do
  let(:organization_logo) { Decidim::Dev.test_file("avatar.jpg", "image/jpeg") }
  let(:footer_logo) { Decidim::Dev.test_file("avatar.jpg", "image/jpeg") }
  let(:organization) { create(:organization, logo: organization_logo, official_img_footer: footer_logo, twitter_handler: "twitter", facebook_handler: "") }
  let!(:admin) { create(:user, :admin, :confirmed, organization: organization) }
  let!(:newsletter) { create :newsletter, :sent, total_recipients: 1 }
  let!(:content_block) do
    create :content_block,
           organization: organization,
           manifest_name: :agenda_events,
           scope_name: :newsletter_template,
           scoped_resource_id: newsletter.id,
           settings: settings
  end

  let(:settings) do
    {
      background_color: organization.colors["primary"],
      font_color_over_bg: Decidim::NewsletterAgenda.default_font_color_over_bg,
      intro_title: "Intro title",
      intro_text: "Intro text",
      footer_address_text: Decidim::NewsletterAgenda.default_address_text
    }
  end

  before do
    Rails.application.config.action_mailer.default_url_options = { port: Capybara.server_port }
    switch_to_host(organization.host)
    login_as admin, scope: :user
  end

  describe "raw template" do
    it "shows the preview template" do
      visit decidim_admin.preview_newsletter_template_path(id: :agenda_events)

      expect(page).to have_content("This is an event title for this agenda")
      expect(page).to have_content("What is happening during the week")
      expect(page).to have_content("Dummy text for body:")
    end
  end

  describe "new newsletter" do
    before do
      visit decidim_admin.root_path
      click_link "Newsletters"
      page.all(:link, "New newsletter").first.click
      page.all(:link, "Use this template").last.click
    end

    context "when automatic customizable settings" do
      it "renders the correct the settings form" do
        expect(page).to have_content("Background color")
        expect(page).to have_field("newsletter[settings][background_color]", with: "#733bce")
        expect(page).to have_content("Font color over background")
        expect(page).to have_field("newsletter[settings][font_color_over_bg]", with: "#ffffff")

        click_link "Body"
        expect(page).to have_content("EVENT 1:")
        expect(page).to have_content("EVENT 2:")
        expect(page).to have_content("EVENT 3:")
        expect(page).to have_content("EVENT 4:")
        expect(page).to have_content("The body of the newsletter can contain up to 4 events")

        click_link "Event 1:"
        expect(page).to have_content("Body event title")

        click_link "Footer"
        expect(page).to have_content("EVENT 1:")
        expect(page).to have_content("EVENT 2:")
        expect(page).to have_content("EVENT 3:")
        expect(page).to have_content("The newsletter footer can contain up to 3 events.")

        click_link "Event 1:"
        expect(page).to have_content("Footer event title")

        expect(page).to have_content("Organization address")
        expect(page).to have_content("Social links title")

        address = ActionController::Base.helpers.strip_tags(content_block.settings.footer_address_text)
        expect(page.html.gsub(/[\n ]+/, " ")).to have_content(address.gsub(/[\n ]+/, " ").strip)
        expect(address.lines[1..3]).to all(match(/^\S/))
      end
    end

    context "when settings from the form" do
      let!(:content_block_new) do
        content_block = Decidim::ContentBlock.find_by(organization: organization, scope_name: :newsletter_template, scoped_resource_id: newsletter.id, manifest_name: :agenda_events)
        content_block.destroy!
        content_block = create(
          :content_block,
          :newsletter_template,
          organization: organization,
          scoped_resource_id: newsletter.id,
          manifest_name: "agenda_events",
          settings: {
            intro_title: Decidim::Faker::Localized.word,
            intro_text: Decidim::Faker::Localized.word,
            body_box_link: I18n.available_locales.index_with { |_locale| Faker::Internet.url }
          }
        )
        content_block
      end

      before do
        fill_in :newsletter_subject_en, with: "Subject"
        find('input[name="newsletter[settings][intro_title_en]"]').fill_in with: "Intro title"
        page.execute_script("document.querySelector('input[name=\"newsletter[settings][intro_text_en]\"]').value = 'Intro text';")
        attach_file("newsletter[images][main_image]", Decidim::Dev.asset("city.jpeg"))

        click_link "Body"
        find('input[name="newsletter[settings][body_title_en]"]').fill_in with: "Body title"
        find('input[name="newsletter[settings][body_subtitle_en]"]').fill_in with: "Body subtitle"

        (1..4).each do |i|
          click_link "Event #{i}:"
          find("input[name='newsletter[settings][body_box_title_#{i}_en]']").fill_in with: "Event title #{i}"
          find("input[name='newsletter[settings][body_box_date_time_#{i}_en]']").fill_in with: i.days.from_now.strftime("%d/%m/%Y")
          find("input[name='newsletter[settings][body_box_description_#{i}_en]']").fill_in with: "Event description #{i}"
          find("input[name='newsletter[settings][body_box_link_text_#{i}_en]']").fill_in with: "Event link text #{i}"
          find("input[name='newsletter[settings][body_box_link_url_#{i}_en]']").fill_in with: "http://www.example.org"
          attach_file("newsletter[images][body_box_image_#{i}]", Decidim::Dev.asset("city2.jpeg"))
        end

        find("input[name='newsletter[settings][body_final_text_en]']").fill_in with: "Final text"

        click_link "Footer"
        find("input[name='newsletter[settings][footer_title_en]']").fill_in with: "Footer title"
        find("input[name='newsletter[settings][mastodon_handler]']").fill_in with: "super_mastodon"

        (1..3).each do |i|
          click_link "Event #{i}:"
          find("input[name='newsletter[settings][footer_box_date_time_#{i}_en]']").fill_in with: 5.days.from_now.strftime("%d/%m/%Y")
          find("input[name='newsletter[settings][footer_box_title_#{i}_en]']").fill_in with: "Footer event title #{i}"
          find("input[name='newsletter[settings][footer_box_link_text_#{i}_en]']").fill_in with: "Footer event link #{i}"
          find("input[name='newsletter[settings][footer_box_link_url_#{i}_en]']").fill_in with: "http://www.example.org/footer"
          attach_file("newsletter[images][footer_box_image_#{i}]", Decidim::Dev.asset("city3.jpeg"))
        end

        page.execute_script("document.querySelector('input[name=\"newsletter[settings][footer_address_text]\"]').value = 'Barcelona, Spain';")

        click_button "Save"
      end

      it "renders the correct the settings form" do
        within_frame do
          expect(page).to have_content(translated("Intro title"))
          expect(page).to have_content(translated("Intro text"))
          expect(page).to have_content(translated("Body title"))
          expect(page).to have_content(translated("Body subtitle"))
          (1..4).each do |i|
            expect(page).to have_content("Event title #{i}")
            expect(page).to have_content(i.days.from_now.strftime("%d/%m/%Y"))
            expect(page).to have_content("Event description #{i}")
            expect(page).to have_content("Event link text #{i}")
          end
          expect(page).to have_css("a[href='http://www.example.org']", count: 4)
          expect(page).to have_content(translated("Final text"))

          (1..3).each do |i|
            expect(page).to have_content(5.days.from_now.strftime("%d/%m/%Y"), count: 3)
            expect(page).to have_content("Footer event title #{i}")
            expect(page).to have_content("Footer event link #{i}")
          end
          expect(page).to have_css("a[href='http://www.example.org/footer']", count: 3)

          expect(page).to have_css("img[src*='avatar.jpg']", count: 2)
          expect(page).to have_css("img[src*='city.jpeg']", count: 1)
          expect(page).to have_css("img[src*='city2.jpeg']", count: 4)
          expect(page).to have_css("img[src*='city3.jpeg']", count: 3)

          expect(page).to have_content(translated("Footer title"))
          expect(page).to have_content("Barcelona, Spain")

          expect(page).to have_css(".footer-social__icon[title='Twitter']")
          expect(page).to have_css(".footer-social__icon[title='Mastodon']")
          expect(page).not_to have_css(".footer-social__icon[title='Facebook']")
          expect(page).not_to have_css(".footer-social__icon[title='Telegram']")

          # no links or images without host
          expect(page.body).not_to include("src=\"/")
          expect(page.body).not_to include("href=\"/")
          expect(page.body).not_to include("url(/")
        end
      end
    end
  end
end
