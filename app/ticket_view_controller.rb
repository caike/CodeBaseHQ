class TicketViewController < UITableViewController

  attr_accessor :ticket_summary


  # callback
  def viewDidLoad
  end

  # callback
  def tableView(tableView, numberOfRowsInSection:section)
    1
  end

  CellID = 'CellIdentifier'
  # callback
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    ticketCell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    ticketCell.textLabel.text = ticket_summary
    ticketCell.detailTextLabel.text = 'something else'
    ticketCell
  end

end