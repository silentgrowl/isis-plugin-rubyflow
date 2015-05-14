require "nokogiri"

module Isis
  module Plugin
    class RubyFlow < Isis::Plugin::Base
      TRIGGERS = %w(!rf !rubyflow)

      def respond_to_msg?(msg, speaker)
        TRIGGERS.include? msg.downcase
      end

      private

      def response_html
        output = %Q[<img src="http://i.imgur.com/TG59FAb.png"> RubyFlow Latest Links] +
                %Q[- #{timestamp} #{zone}<br>]
        scrape.reduce(output) do |a, e|
          link = e.children.css('a')
          a += %Q[<a href="http://www.rubyflow.com#{link.attr('href').value}">#{link.text}</a><br>]
        end
      end

      def response_md
        output = %Q[RubyFlow Latest Links] +
                %Q[- #{timestamp} #{zone}\n]
        scrape.reduce(output) do |a, e|
          link = e.children.css('a')
          a += %Q[<http://www.rubyflow.com#{link.attr('href').value}|#{link.text}>\n]
        end
      end

      def response_text
        output = ["RubyFlow Latest Links - #{timestamp} #{zone}"]
        scrape.reduce(output) do |a, e|
          link = e.children.css('a')
          a.push %Q[#{link.text}: #{link.attr('href').value}]
        end
      end

      def scrape
        page = Nokogiri.HTML(open('http://www.rubyflow.com'))
        page.css('.posts .post .body h1')[0..4]
      end
    end
  end
end
