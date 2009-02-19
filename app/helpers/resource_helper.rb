module ResourceHelper
  def ue(val)
    return CGI::unescape(val)
  end

  def esc(val)
    return CGI::escape(val)
  end

  def resource_count
    r = []
    @groups.each do |g|
      g[:data].each do |x|
        r << x.id if !r.include?(x.id)
      end
    end
    r.length
  end
end
