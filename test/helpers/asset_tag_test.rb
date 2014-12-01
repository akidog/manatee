require_relative '../test_helper'

class AssetTagTest < JavascriptRenderer::ViewTest

  def setup
    reset_renderer do |config|
      config.fonts_path      = '/fonts'
      config.audios_path     = '/audios'
      config.videos_path     = '/videos'
      config.images_path     = '/images'
      config.javascript_path = ''
      config.stylesheet_path = ''
    end
  end

  AudioTagParams = {
    %( "xml.wav"                                                      ) => %(<audio src="/audios/xml.wav"></audio>),
    %( "rss.wav", { autoplay: true, controls: true }                  ) => %(<audio autoplay="autoplay" controls="controls" src="/audios/rss.wav"></audio>),
    %( "http://media.rubyonrails.org/audio/rails_blog_2.mov"          ) => %(<audio src="http://media.rubyonrails.org/audio/rails_blog_2.mov"></audio>),
    %( "//media.rubyonrails.org/audio/rails_blog_2.mov"               ) => %(<audio src="//media.rubyonrails.org/audio/rails_blog_2.mov"></audio>),
    %( "audio.mp3", "audio.ogg"                                       ) => %(<audio><source src="/audios/audio.mp3" /><source src="/audios/audio.ogg" /></audio>),
    %( "audio.mp3", "audio.ogg"                                       ) => %(<audio><source src="/audios/audio.mp3" /><source src="/audios/audio.ogg" /></audio>),
    %( "audio.mp3", "audio.ogg", { autobuffer: true, controls: true } ) => %(<audio autobuffer="autobuffer" controls="controls"><source src="/audios/audio.mp3" /><source src="/audios/audio.ogg" /></audio>)
 }

  def test_audio_tag
    AudioTagParams.each do |params, expected|
      assert_dom_js_helper expected, :audioTag, params
    end
  end

  AutoDiscoveryLinkTagParams = {
    %(                                                                  ) => %(<link href="http://www.example.com" rel="alternate" title="RSS" type="application/rss+xml" />),
    %( 'rss'                                                            ) => %(<link href="http://www.example.com" rel="alternate" title="RSS" type="application/rss+xml" />),
    %( 'atom'                                                           ) => %(<link href="http://www.example.com" rel="alternate" title="ATOM" type="application/atom+xml" />),
    %( 'rss',  "http://localhost/feed"                                  ) => %(<link href="http://localhost/feed" rel="alternate" title="RSS" type="application/rss+xml" />),
    %( 'rss',  "//localhost/feed"                                       ) => %(<link href="//localhost/feed" rel="alternate" title="RSS" type="application/rss+xml" />),
    %( 'rss',  null, { title: "My RSS" }                                ) => %(<link href="http://www.example.com" rel="alternate" title="My RSS" type="application/rss+xml" />),
    %( null,   null, { type: "text/html" }                              ) => %(<link href="http://www.example.com" rel="alternate" title="" type="text/html" />),
    %( null,   null, { title: "No stream.. really", type: "text/html" } ) => %(<link href="http://www.example.com" rel="alternate" title="No stream.. really" type="text/html" />),
    %( 'rss',  null, { title: "My RSS", type: "text/html" }             ) => %(<link href="http://www.example.com" rel="alternate" title="My RSS" type="text/html" />),
    %( 'atom', null, { rel: "Not so alternate" }                        ) => %(<link href="http://www.example.com" rel="Not so alternate" title="ATOM" type="application/atom+xml" />)
  }

  def test_auto_discovery_link_tag
    AutoDiscoveryLinkTagParams.each do |params, expected|
      assert_dom_js_helper expected, :autoDiscoveryLinkTag, params
    end
  end

  FaviconLinkTagParams = {
    %(                                                               ) => %(<link href="favicon.ico" rel="shortcut icon" type="image/x-icon" />),
    %( 'favicon.ico'                                                 ) => %(<link href="favicon.ico" rel="shortcut icon" type="image/x-icon" />),
    %( 'favicon.ico', { rel: 'foo' }                                 ) => %(<link href="favicon.ico" rel="foo" type="image/x-icon" />),
    %( 'favicon.ico', { rel: 'foo', type: 'bar' }                    ) => %(<link href="favicon.ico" rel="foo" type="bar" />),
    %( 'mb-icon.png', { rel: 'apple-touch-icon', type: 'image/png' } ) => %(<link href="mb-icon.png" rel="apple-touch-icon" type="image/png" />)
  }

  def test_favicon_link_tag
    FaviconLinkTagParams.each do |params, expected|
      assert_dom_js_helper expected, :faviconLinkTag, params
    end
  end

  def test_image_alt
    [nil, '/', '/foo/bar/', 'foo/bar/'].each do |prefix|
      assert_helper 'Rails',                           :imageAlt, "#{prefix}rails.png"
      assert_helper 'Rails',                           :imageAlt, "#{prefix}rails-9c0a079bdd7701d7e729bd956823d153.png"
      assert_helper 'Long file name with hyphens',     :imageAlt, "#{prefix}long-file-name-with-hyphens.png"
      assert_helper 'Long file name with underscores', :imageAlt, "#{prefix}long_file_name_with_underscores.png"
    end
  end

  GifEmbededSrc = "data:image/gif;base64,R0lGODlhAQABAID/AMDAwAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
  PngEmbededSrc = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg=="
  ImageTagParams = {
    %( "xml.png"                                     ) => %(<img alt="Xml" src="/images/xml.png" />),
    %( "rss.gif",   { alt: "rss syndication" }       ) => %(<img alt="rss syndication" src="/images/rss.gif" />),
    %( "gold.png",  { size: "20" }                   ) => %(<img alt="Gold" height="20" src="/images/gold.png" width="20" />),
    %( "gold.png",  { size: "45x70" }                ) => %(<img alt="Gold" height="70" src="/images/gold.png" width="45" />),
    %( "gold.png",  { size: "45x70" }                ) => %(<img alt="Gold" height="70" src="/images/gold.png" width="45" />),
    %( "error.png", { size: "45 x 70" }              ) => %(<img alt="Error" src="/images/error.png" />),
    %( "error.png", { size: "x" }                    ) => %(<img alt="Error" src="/images/error.png" />),
    %( "google.com.png"                              ) => %(<img alt="Google.com" src="/images/google.com.png" />),
    %( "slash..png"                                  ) => %(<img alt="Slash." src="/images/slash..png" />),
    %( ".pdf.png"                                    ) => %(<img alt=".pdf" src="/images/.pdf.png" />),
    %( "http://www.rubyonrails.com/images/rails.png" ) => %(<img alt="Rails" src="http://www.rubyonrails.com/images/rails.png" />),
    %( "//www.rubyonrails.com/images/rails.png"      ) => %(<img alt="Rails" src="//www.rubyonrails.com/images/rails.png" />),
    %( "mouse.png", { alt: null }                    ) => %(<img src="/images/mouse.png" />),
    %( "#{GifEmbededSrc}", { alt: null }             ) => %(<img src="#{GifEmbededSrc}" />),
    %( "#{PngEmbededSrc}"                            ) => %(<img src="#{PngEmbededSrc}" />),
    %( "#{PngEmbededSrc}", { alt: 'Red Dot'}         ) => %(<img src="#{PngEmbededSrc}" alt="Red Dot" />),
    %( ""                                            ) => %(<img src="" />)
  }

  def test_image_tag
    ImageTagParams.each do |params, expected|
      assert_dom_js_helper expected, :imageTag, params
    end
  end

  def test_javascript_include_tag
    assert_dom_helper '<script src="/foo.js"></script>',  :javascriptIncludeTag, '/foo'
    assert_dom_helper '<script src="/foo"></script>',     :javascriptIncludeTag, '/foo', format: false
    assert_dom_helper '<script src="/foo.bar"></script>', :javascriptIncludeTag, '/foo', format: 'bar'
  end

  def test_javascript_include_tag_with_full_url
    assert_dom_helper '<script src="http://foo.bar/javascript.js"></script>', :javascriptIncludeTag, 'http://foo.bar/javascript.js'
  end

  def test_javascript_multiple_include_tag
    assert_dom_helper '<script src="/foo.js"></script><script src="/bar.js"></script>',   :javascriptIncludeTag, '/foo', '/bar'
    assert_dom_helper '<script src="/foo"></script><script src="/bar"></script>',         :javascriptIncludeTag, '/foo', '/bar', format: false
    assert_dom_helper '<script src="/foo.foo"></script><script src="/bar.foo"></script>', :javascriptIncludeTag, '/foo', '/bar', format: 'foo'
  end

  def test_javascript_multiple_include_tag_with_full_url
    assert_dom_helper '<script src="http://foo.bar/javascript.js"></script><script src="http://bar.foo/javascript.js"></script>', :javascriptIncludeTag, 'http://foo.bar/javascript.js', 'http://bar.foo/javascript.js'
  end

  def test_stylesheet_include_tag
    assert_dom_helper '<link rel="stylesheet" media="screen" href="/foo.css"/>', :stylesheetLinkTag, '/foo'
    assert_dom_helper '<link rel="stylesheet" media="screen" href="/foo"/>',     :stylesheetLinkTag, '/foo', format: false
    assert_dom_helper '<link rel="stylesheet" media="screen" href="/foo.bar"/>', :stylesheetLinkTag, '/foo', format: 'bar'
  end

  def test_stylesheet_include_tag_with_options
    assert_dom_helper '<link rel="stylesheet" media="all" href="/foo.css"/>',                      :stylesheetLinkTag, '/foo', media:     'all'
    assert_dom_helper '<link rel="stylesheet" media="screen" attribute="what?" href="/foo.css"/>', :stylesheetLinkTag, '/foo', attribute: 'what?'
  end

  def test_stylesheet_include_tag_with_full_url
    assert_dom_helper '<link rel="stylesheet" media="screen" href="http://foo.bar/stylesheet.css"/>', :stylesheetLinkTag, 'http://foo.bar/stylesheet.css'
  end

  def test_stylesheet_multiple_include_tag
    assert_dom_helper '<link rel="stylesheet" media="screen" href="/foo.css"/><link rel="stylesheet" media="screen" href="/bar.css"/>', :stylesheetLinkTag, '/foo', '/bar'
    assert_dom_helper '<link rel="stylesheet" media="screen" href="/foo"/><link rel="stylesheet" media="screen" href="/bar"/>',         :stylesheetLinkTag, '/foo', '/bar', format: false
    assert_dom_helper '<link rel="stylesheet" media="screen" href="/foo.foo"/><link rel="stylesheet" media="screen" href="/bar.foo"/>', :stylesheetLinkTag, '/foo', '/bar', format: 'foo'
  end

  def test_stylesheet_multiple_include_tag_with_options
    assert_dom_helper '<link media="all" rel="stylesheet" href="/foo.css"/><link media="all" rel="stylesheet" href="/bar.css"/>',                                           :stylesheetLinkTag, '/foo', '/bar', media:     'all'
    assert_dom_helper '<link attribute="what?" rel="stylesheet" media="screen" href="/foo.css"/><link attribute="what?" rel="stylesheet" media="screen" href="/bar.css"/>', :stylesheetLinkTag, '/foo', '/bar', attribute: 'what?'
  end

  def test_stylesheet_multiple_include_tag_with_full_url
    assert_dom_helper '<link rel="stylesheet" media="screen" href="http://foo.bar/stylesheet.css"/><link rel="stylesheet" media="screen" href="http://bar.foo/stylesheet.css"/>', :stylesheetLinkTag, 'http://foo.bar/stylesheet.css', 'http://bar.foo/stylesheet.css'
  end

  VideoTagParams = {
    %( "xml.ogg"                                                            ) => %(<video src="/videos/xml.ogg"></video>),
    %( "rss.m4v",     { autoplay: true, controls: true }                    ) => %(<video autoplay="autoplay" controls="controls" src="/videos/rss.m4v"></video>),
    %( "rss.m4v",     { autobuffer: true }                                  ) => %(<video autobuffer="autobuffer" src="/videos/rss.m4v"></video>),
    %( "gold.m4v",    { size: "160x120" }                                   ) => %(<video height="120" src="/videos/gold.m4v" width="160"></video>),
    %( "gold.m4v",    { size: "320x240" }                                   ) => %(<video height="240" src="/videos/gold.m4v" width="320"></video>),
    %( "trailer.ogg", { poster: "screenshot.png" }                          ) => %(<video poster="/images/screenshot.png" src="/videos/trailer.ogg"></video>),
    %( "error.avi",   { size: "100" }                                       ) => %(<video height="100" src="/videos/error.avi" width="100"></video>),
    %( "error.avi",   { size: "100 x 100"}                                  ) => %(<video src="/videos/error.avi"></video>),
    %( "error.avi",   { size: "x" }                                         ) => %(<video src="/videos/error.avi"></video>),
    %( "http://media.rubyonrails.org/video/rails_blog_2.mov"                ) => %(<video src="http://media.rubyonrails.org/video/rails_blog_2.mov"></video>),
    %( "//media.rubyonrails.org/video/rails_blog_2.mov"                     ) => %(<video src="//media.rubyonrails.org/video/rails_blog_2.mov"></video>),
    %( "multiple.ogg", "multiple.avi"                                       ) => %(<video><source src="/videos/multiple.ogg" /><source src="/videos/multiple.avi" /></video>),
    %( "multiple.ogg", "multiple.avi"                                       ) => %(<video><source src="/videos/multiple.ogg" /><source src="/videos/multiple.avi" /></video>),
    %( "multiple.ogg", "multiple.avi", { size: "160x120",  controls: true } ) => %(<video controls="controls" height="120" width="160"><source src="/videos/multiple.ogg" /><source src="/videos/multiple.avi" /></video>)
  }

  def test_video_tag
    VideoTagParams.each do |params, expected|
      assert_dom_js_helper expected, :videoTag, params
    end
  end

end
