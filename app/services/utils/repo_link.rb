module Utils
  module RepoLink
    def self.shorten(url)
      url = url.start_with?('https://github.com/') ? url.gsub(%r{https://github\.com/}, '') : nil
      [:success, url]
    end
  end
end