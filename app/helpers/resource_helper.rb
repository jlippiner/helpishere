module ResourceHelper
  def ue(val)
    return CGI::unescape(val)
  end

  def esc(val)
    return CGI::escape(val)
  end

  def check_cat(rs,c)    
    rs.each do |i|      
      return true if i.categories.include?(c)
    end
    return false
  end
end
