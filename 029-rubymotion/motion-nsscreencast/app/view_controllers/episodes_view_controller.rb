class EpisodesViewController < UITableViewController
  def init
    super.initWithStyle(UITableViewStylePlain)
  end

  def viewDidLoad
    super
    self.title = "Episodes"

    @episodes ||= []

    ApiClient.fetch_episodes do |success, episodes|
      if success
        @episodes = episodes
        p "Received #{@episodes.length} episodes"
        self.tableView.reloadData
      else
        App.alert("Oops!")
      end
    end
  end

  # - (void)tableView:(UITableView)tableView numberOfRowsInSection:(NSInteger)section;
  def tableView(tableView, numberOfRowsInSection:section)
    @episodes.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell_id = "cell"
    cell = tableView.dequeueReusableCellWithIdentifier cell_id
    if cell.nil?
      cell = UITableViewCell.alloc.initWithStyle UITableViewCellStyleDefault, reuseIdentifier:cell_id
    end

    episode = @episodes[indexPath.row]
    cell.textLabel.text = episode.title
    cell
  end
end
