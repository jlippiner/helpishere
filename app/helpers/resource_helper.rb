module ResourceHelper
  def ue(val)
    return CGI::unescape(val)
  end

  def esc(val)
    return CGI::escape(val)
  end
end
