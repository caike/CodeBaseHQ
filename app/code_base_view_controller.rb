class CodeBaseViewController < UITableViewController

  attr_accessor :app_settings


  def viewDidLoad
    buildSearchbar()
    loadTickets()
  end

  def tableView(tableView, numberOfRowsInSection:section)
    tickets.size
  end

  CellID = 'CellIdentifier'

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    ticket = tickets[indexPath.row]

    ticketCell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    ticketCell.textLabel.text = ticket
    ticketCell.detailTextLabel.text = 'description goes here'

    ticketCell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:false)
    ticketViewController = TicketViewController.alloc.init
    ticketViewController.ticket_summary = tickets[indexPath.row]
    navigationController.pushViewController(ticketViewController, animated:true)
  end


  private

    def reloadTickets(tickets)
      @tickets = tickets
      view.reloadData
    end

    def tickets
      @filtered_tickets.any? ? @filtered_tickets : (@tickets || [])
    end

    def loadTickets
      @tickets = []
      tickets_url = "#{app_settings[:base_uri]}#{app_settings[:project_name]}/tickets?query=status:New%20status:%22In%20Progress%22"
      BubbleWrap::HTTP.get(tickets_url, http_request_options) do |response|
        parser = BubbleWrap::XML.parse(response.body.to_str)
        tickets = parser.tickets
        reloadTickets(tickets)
      end

    end

    def http_request_options
      {
        headers: {
          'Content-type' => 'application/xml',
          'Accept' => 'application/xml',
          'Authorization' => "#{app_settings[:authorization_header]}"
        }
      }
    end

    def buildSearchbar
      @filtered_tickets = []
      searchBar = UISearchBar.alloc.initWithFrame([[0,0],[self.tableView.frame.size.width, 0]])
      searchBar.delegate = self;
      searchBar.showsCancelButton = true;
      searchBar.sizeToFit 
      view.tableHeaderView = searchBar

      searchBar.placeholder = 'Keyword'
    end

    def searchBarCancelButtonClicked(searchBar)
      #p "searchBarCancelButtonClicked"
      @filtered_tickets.clear
      view.reloadData
      searchBar.resignFirstResponder
    end

    def searchBar(searchBar, textDidChange:text)
      @filtered_tickets = @tickets.select { |t| t =~ Regexp.new(text, 'i') }
      view.reloadData
    end

    def searchBarSearchButtonClicked(searchBar)
      view.reloadData
      searchBar.resignFirstResponder
    end

end