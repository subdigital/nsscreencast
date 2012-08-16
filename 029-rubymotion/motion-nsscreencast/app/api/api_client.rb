class ApiClient
  def self.fetch_episodes(&block)
    BubbleWrap::HTTP.get("http://nsscreencast.com/api/episodes.json") do |response|
      if response.ok?
        json = BubbleWrap::JSON.parse(response.body)
        episodes = json.map {|ej| Episode.from_json(ej["episode"])}
        block.call(true, episodes)
      else
        block.call(false, nil)
      end
    end
  end
end
