class GMap
  def self.header(options = {})
    options[:with_vml] = true unless options.has_key?(:with_vml)
    options[:hl] ||= ''
    options[:local_search] = false unless options.has_key?(:local_search)
    api_key = ApiKey.get(options)
    a = "<script src=\"http://maps.google.com/maps?file=api&amp;v=2.x&amp;key=#{api_key}&amp;hl=#{options[:hl]}\" type=\"text/javascript\"></script>\n"
    a << "<script src=\"#{ActionController::Base.relative_url_root}/javascripts/ym4r-gm.js\" type=\"text/javascript\"></script>\n" unless options[:without_js]
    a << "<style type=\"text/css\">\n v\:* { behavior:url(#default#VML);}\n</style>" if options[:with_vml]
    a << "<script src=\"http://www.google.com/uds/api?file=uds.js&amp;v=1.0\" type=\"text/javascript\"></script>" if options[:local_search]
    a << "<script src=\"http://www.google.com/uds/solutions/localsearch/gmlocalsearch.js\" type=\"text/javascript\"></script>\n" if options[:local_search]
    a << "<style type=\"text/css\">@import url(\"http://www.google.com/uds/css/gsearch.css\");@import url(\"http://www.google.com/uds/solutions/localsearch/gmlocalsearch.css\");}</style>" if options[:local_search]
    a
  end
end

