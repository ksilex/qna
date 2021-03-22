module ApplicationHelper
  def flash_class(level)
    { success: "alert alert-success alert-dismissible fade show",
      error: "alert alert-danger alert-dismissible fade show",
      alert: "alert alert-warning alert-dismissible fade show",
      notice: "alert alert-info alert-dismissible fade show" }.stringify_keys[level.to_s]
  end

  def gist?(link)
    link[:url].include?('gist.github.com')
  end

  def gist(link)
    @client ||= Octokit::Client.new(access_token: '352f1f578c4da9a7bc84eaf6df049a4a073ee058')
    response = @client.gist(link.url.split('/').last)
  end
end
