# redMine - project management software
# Copyright (C) 2006-2009  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require File.dirname(__FILE__) + '/../test_helper'

class JournalObserverTest < ActiveSupport::TestCase
  fixtures :issues, :issue_statuses, :journals

  def setup
    ActionMailer::Base.deliveries.clear
    @journal = Journal.find 1
    if (i = Issue.find(:first)).journals.empty?
      i.init_journal(User.current, 'Creation') # Make sure the initial journal is created
      i.save
    end
  end

  # context: issue_updated notified_events
  def test_create_should_send_email_notification_with_issue_updated
    Setting.notified_events = ['issue_updated']
    issue = Issue.find(:first)
    user = User.find(:first)
    issue.init_journal(user)

    assert issue.send(:create_journal)
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  def test_create_should_not_send_email_notification_without_issue_updated
    Setting.notified_events = []
    issue = Issue.find(:first)
    user = User.find(:first)
    issue.init_journal(user)

    assert issue.save
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  # context: issue_note_added notified_events
  def test_create_should_send_email_notification_with_issue_note_added
    Setting.notified_events = ['issue_note_added']
    issue = Issue.find(:first)
    user = User.find(:first)
    issue.init_journal(user, 'This update has a note')

    assert issue.save
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  def test_create_should_not_send_email_notification_without_issue_note_added
    Setting.notified_events = []
    issue = Issue.find(:first)
    user = User.find(:first)
    issue.init_journal(user, 'This update has a note')
    
    assert issue.save
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  # context: issue_status_updated notified_events
  def test_create_should_send_email_notification_with_issue_status_updated
    Setting.notified_events = ['issue_status_updated']
    issue = Issue.find(:first)
    user = User.find(:first)
    issue.init_journal(user)
    issue.status = IssueStatus.last

    assert issue.save
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  def test_create_should_not_send_email_notification_without_issue_status_updated
    Setting.notified_events = []
    issue = Issue.find(:first)
    user = User.find(:first)
    issue.init_journal(user)
    issue.status = IssueStatus.last
    
    assert issue.save
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  # context: issue_priority_updated notified_events
  def test_create_should_send_email_notification_with_issue_priority_updated
    Setting.notified_events = ['issue_priority_updated']
    issue = Issue.find(:first)
    user = User.find(:first)
    issue.init_journal(user)
    issue.priority = IssuePriority.last

    assert issue.save
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  def test_create_should_not_send_email_notification_without_issue_priority_updated
    Setting.notified_events = []
    issue = Issue.find(:first)
    user = User.find(:first)
    issue.init_journal(user)
    issue.priority = IssuePriority.last
    
    assert issue.save
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

end
