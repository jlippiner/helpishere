module ResourceHelper
  def ue(val)
    return CGI::unescape(params[val])
  end
end
