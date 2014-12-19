require_relative '../test_helper'

class AssetUrlTest < JavascriptRenderer::ViewTest

  def setup
    config_renderer do |config|
      config.fonts_path      = '/fonts'
      config.audios_path     = '/audios'
      config.videos_path     = '/videos'
      config.images_path     = '/images'
      config.javascript_path = '/javascripts'
      config.stylesheet_path = '/stylesheets'
    end
  end

  ComputeAssetPathParams = {
    %( "robots.txt"                                                        ) => "/robots.txt",
    %( "/robots.txt"                                                       ) => "/robots.txt",
    %( "foo.js",      { type: 'javascript' }                               ) => "/javascripts/foo.js",
    %( "/foo.js",     { type: 'javascript' }                               ) => "/foo.js",
    %( "foo.css",     { type: 'stylesheet' }                               ) => "/stylesheets/foo.css",
    %( "robots.txt",  { domain: 'http://example.com' }                     ) => "http://example.com/robots.txt",
    %( "/robots.txt", { domain: 'http://example.com' }                     ) => "http://example.com/robots.txt",
    %( "foo.js",      { domain: 'http://example.com', type: 'javascript' } ) => "http://example.com/javascripts/foo.js",
    %( "/foo.js",     { domain: 'http://example.com', type: 'javascript' } ) => "http://example.com/foo.js",
    %( "foo.css",     { domain: 'http://example.com', type: 'stylesheet' } ) => "http://example.com/stylesheets/foo.css"
  }

  def test_compute_asset_path
    ComputeAssetPathParams.each do |params, expected|
      assert_js_helper expected, :computeAssetPath, params
    end
  end

  AssetPathParams = {
    %( "foo"                                                                                           ) => '/foo',
    %( "style.css"                                                                                     ) => '/style.css',
    %( "xmlhr.js"                                                                                      ) => '/xmlhr.js',
    %( "xml.png"                                                                                       ) => '/xml.png',
    %( "dir/xml.png"                                                                                   ) => '/dir/xml.png',
    %( "/dir/xml.png"                                                                                  ) => '/dir/xml.png',
    %( "script.min"                                                                                    ) => '/script.min',
    %( "script.min.js"                                                                                 ) => '/script.min.js',
    %( "style.min"                                                                                     ) => '/style.min',
    %( "style.min.css"                                                                                 ) => '/style.min.css',
    %( "http://www.outside.com/image.jpg"                                                              ) => 'http://www.outside.com/image.jpg',
    %( "HTTP://www.outside.com/image.jpg"                                                              ) => 'HTTP://www.outside.com/image.jpg',
    %( "style",                            { type: 'stylesheet' }                                      ) => '/stylesheets/style.css',
    %( "xmlhr",                            { type: 'javascript' }                                      ) => '/javascripts/xmlhr.js',
    %( "xml.png",                          { type: 'image'      }                                      ) => '/images/xml.png',
    %( "foo",                              { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/foo',
    %( "style.css",                        { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/style.css',
    %( "xmlhr.js",                         { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/xmlhr.js',
    %( "xml.png",                          { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/xml.png',
    %( "dir/xml.png",                      { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/dir/xml.png',
    %( "/dir/xml.png",                     { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/dir/xml.png',
    %( "script.min",                       { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/script.min',
    %( "script.min.js",                    { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/script.min.js',
    %( "style.min",                        { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/style.min',
    %( "style.min.css",                    { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/style.min.css',
    %( "http://www.outside.com/image.jpg", { domain: 'http://other.example.com' }                      ) => 'http://www.outside.com/image.jpg',
    %( "HTTP://www.outside.com/image.jpg", { domain: 'http://other.example.com' }                      ) => 'HTTP://www.outside.com/image.jpg',
    %( "style",                            { domain: 'http://other.example.com', type: 'stylesheet' }  ) => 'http://other.example.com/stylesheets/style.css',
    %( "xmlhr",                            { domain: 'http://other.example.com', type: 'javascript' }  ) => 'http://other.example.com/javascripts/xmlhr.js',
    %( "xml.png",                          { domain: 'http://other.example.com', type: 'image'      }  ) => 'http://other.example.com/images/xml.png'
  }

  def test_asset_path
    AssetPathParams.each do |params, expected|
      assert_js_helper expected, :assetPath, params
    end
  end

  AssetUrlParams = {
    %( "foo"                                                                                           ) => 'http://www.example.com/foo',
    %( "style.css"                                                                                     ) => 'http://www.example.com/style.css',
    %( "xmlhr.js"                                                                                      ) => 'http://www.example.com/xmlhr.js',
    %( "xml.png"                                                                                       ) => 'http://www.example.com/xml.png',
    %( "dir/xml.png"                                                                                   ) => 'http://www.example.com/dir/xml.png',
    %( "/dir/xml.png"                                                                                  ) => 'http://www.example.com/dir/xml.png',
    %( "script.min"                                                                                    ) => 'http://www.example.com/script.min',
    %( "script.min.js"                                                                                 ) => 'http://www.example.com/script.min.js',
    %( "style.min"                                                                                     ) => 'http://www.example.com/style.min',
    %( "style.min.css"                                                                                 ) => 'http://www.example.com/style.min.css',
    %( "http://www.outside.com/image.jpg"                                                              ) => 'http://www.outside.com/image.jpg',
    %( "HTTP://www.outside.com/image.jpg"                                                              ) => 'HTTP://www.outside.com/image.jpg',
    %( "style",                            { type: 'stylesheet' }                                      ) => 'http://www.example.com/stylesheets/style.css',
    %( "xmlhr",                            { type: 'javascript' }                                      ) => 'http://www.example.com/javascripts/xmlhr.js',
    %( "xml.png",                          { type: 'image'      }                                      ) => 'http://www.example.com/images/xml.png',
    %( "foo",                              { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/foo',
    %( "style.css",                        { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/style.css',
    %( "xmlhr.js",                         { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/xmlhr.js',
    %( "xml.png",                          { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/xml.png',
    %( "dir/xml.png",                      { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/dir/xml.png',
    %( "/dir/xml.png",                     { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/dir/xml.png',
    %( "script.min",                       { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/script.min',
    %( "script.min.js",                    { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/script.min.js',
    %( "style.min",                        { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/style.min',
    %( "style.min.css",                    { domain: 'http://other.example.com' }                      ) => 'http://other.example.com/style.min.css',
    %( "http://www.outside.com/image.jpg", { domain: 'http://other.example.com' }                      ) => 'http://www.outside.com/image.jpg',
    %( "HTTP://www.outside.com/image.jpg", { domain: 'http://other.example.com' }                      ) => 'HTTP://www.outside.com/image.jpg',
    %( "style",                            { domain: 'http://other.example.com', type: 'stylesheet' }  ) => 'http://other.example.com/stylesheets/style.css',
    %( "xmlhr",                            { domain: 'http://other.example.com', type: 'javascript' }  ) => 'http://other.example.com/javascripts/xmlhr.js',
    %( "xml.png",                          { domain: 'http://other.example.com', type: 'image'      }  ) => 'http://other.example.com/images/xml.png'
  }

  def test_asset_url
    AssetUrlParams.each do |params, expected|
      assert_js_helper expected, :assetUrl, params
    end
  end

  AudioPathParams = {
    %( "xml"                                                ) => '/audios/xml',
    %( "xml.wav"                                            ) => '/audios/xml.wav',
    %( "dir/xml.wav"                                        ) => '/audios/dir/xml.wav',
    %( "/dir/xml.wav"                                       ) => '/dir/xml.wav',
    %( "xml",          { domain: 'http://www.example.com' } ) => 'http://www.example.com/audios/xml',
    %( "xml.wav",      { domain: 'http://www.example.com' } ) => 'http://www.example.com/audios/xml.wav',
    %( "dir/xml.wav",  { domain: 'http://www.example.com' } ) => 'http://www.example.com/audios/dir/xml.wav',
    %( "/dir/xml.wav", { domain: 'http://www.example.com' } ) => 'http://www.example.com/dir/xml.wav'
  }

  def test_audio_path
    AudioPathParams.each do |params, expected|
      assert_js_helper expected, :audioPath, params
    end
  end

  AudioUrlParams = {
    %( "xml"                                                  ) => 'http://www.example.com/audios/xml',
    %( "xml.wav"                                              ) => 'http://www.example.com/audios/xml.wav',
    %( "dir/xml.wav"                                          ) => 'http://www.example.com/audios/dir/xml.wav',
    %( "/dir/xml.wav"                                         ) => 'http://www.example.com/dir/xml.wav',
    %( "xml",          { domain: 'http://other.example.com' } ) => 'http://other.example.com/audios/xml',
    %( "xml.wav",      { domain: 'http://other.example.com' } ) => 'http://other.example.com/audios/xml.wav',
    %( "dir/xml.wav",  { domain: 'http://other.example.com' } ) => 'http://other.example.com/audios/dir/xml.wav',
    %( "/dir/xml.wav", { domain: 'http://other.example.com' } ) => 'http://other.example.com/dir/xml.wav'
  }

  def test_audioUrl
    AudioUrlParams.each do |params, expected|
      assert_js_helper expected, :audioUrl, params
    end
  end

  FontPathParams = {
    %( "font.eot"                                             ) => '/fonts/font.eot',
    %( "font.eot#iefix"                                       ) => '/fonts/font.eot#iefix',
    %( "font.woff"                                            ) => '/fonts/font.woff',
    %( "font.ttf"                                             ) => '/fonts/font.ttf',
    %( "font.ttf?123"                                         ) => '/fonts/font.ttf?123',
    %( "font.eot",       { domain: 'http://www.example.com' } ) => 'http://www.example.com/fonts/font.eot',
    %( "font.eot#iefix", { domain: 'http://www.example.com' } ) => 'http://www.example.com/fonts/font.eot#iefix',
    %( "font.woff",      { domain: 'http://www.example.com' } ) => 'http://www.example.com/fonts/font.woff',
    %( "font.ttf",       { domain: 'http://www.example.com' } ) => 'http://www.example.com/fonts/font.ttf',
    %( "font.ttf?123",   { domain: 'http://www.example.com' } ) => 'http://www.example.com/fonts/font.ttf?123'
  }

  def test_font_path
    FontPathParams.each do |params, expected|
      assert_js_helper expected, :fontPath, params
    end
  end

  FontUrlParams = {
    %( "font.eot"                                               ) => 'http://www.example.com/fonts/font.eot',
    %( "font.eot#iefix"                                         ) => 'http://www.example.com/fonts/font.eot#iefix',
    %( "font.woff"                                              ) => 'http://www.example.com/fonts/font.woff',
    %( "font.ttf"                                               ) => 'http://www.example.com/fonts/font.ttf',
    %( "font.ttf?123"                                           ) => 'http://www.example.com/fonts/font.ttf?123',
    %( "font.eot",       { domain: 'http://other.example.com' } ) => 'http://other.example.com/fonts/font.eot',
    %( "font.eot#iefix", { domain: 'http://other.example.com' } ) => 'http://other.example.com/fonts/font.eot#iefix',
    %( "font.woff",      { domain: 'http://other.example.com' } ) => 'http://other.example.com/fonts/font.woff',
    %( "font.ttf",       { domain: 'http://other.example.com' } ) => 'http://other.example.com/fonts/font.ttf',
    %( "font.ttf?123",   { domain: 'http://other.example.com' } ) => 'http://other.example.com/fonts/font.ttf?123'
  }

  def test_font_url
    FontUrlParams.each do |params, expected|
      assert_js_helper expected, :fontUrl, params
    end
  end

  ImagePathParams = {
    %( "xml"                                                ) => '/images/xml',
    %( "xml.png"                                            ) => '/images/xml.png',
    %( "dir/xml.png"                                        ) => '/images/dir/xml.png',
    %( "/dir/xml.png"                                       ) => '/dir/xml.png',
    %( "xml",          { domain: 'http://www.example.com' } ) => 'http://www.example.com/images/xml',
    %( "xml.png",      { domain: 'http://www.example.com' } ) => 'http://www.example.com/images/xml.png',
    %( "dir/xml.png",  { domain: 'http://www.example.com' } ) => 'http://www.example.com/images/dir/xml.png',
    %( "/dir/xml.png", { domain: 'http://www.example.com' } ) => 'http://www.example.com/dir/xml.png'
  }

  def test_image_path
    ImagePathParams.each do |params, expected|
      assert_js_helper expected, :imagePath, params
    end
  end

  ImageUrlParams = {
    %( "xml"                                                  ) => 'http://www.example.com/images/xml',
    %( "xml.png"                                              ) => 'http://www.example.com/images/xml.png',
    %( "dir/xml.png"                                          ) => 'http://www.example.com/images/dir/xml.png',
    %( "/dir/xml.png"                                         ) => 'http://www.example.com/dir/xml.png',
    %( "xml",          { domain: 'http://other.example.com' } ) => 'http://other.example.com/images/xml',
    %( "xml.png",      { domain: 'http://other.example.com' } ) => 'http://other.example.com/images/xml.png',
    %( "dir/xml.png",  { domain: 'http://other.example.com' } ) => 'http://other.example.com/images/dir/xml.png',
    %( "/dir/xml.png", { domain: 'http://other.example.com' } ) => 'http://other.example.com/dir/xml.png'
  }

  def test_image_url
    ImageUrlParams.each do |params, expected|
      assert_js_helper expected, :imageUrl, params
    end
  end

  JavascriptPathParams = {
    %( "xmlhr"                                                   ) => '/javascripts/xmlhr.js',
    %( "super/xmlhr"                                             ) => '/javascripts/super/xmlhr.js',
    %( "/super/xmlhr.js"                                         ) => '/super/xmlhr.js',
    %( "xmlhr.min"                                               ) => '/javascripts/xmlhr.min.js',
    %( "xmlhr.min.js"                                            ) => '/javascripts/xmlhr.min.js',
    %( "xmlhr.js?123"                                            ) => '/javascripts/xmlhr.js?123',
    %( "xmlhr.js?body=1"                                         ) => '/javascripts/xmlhr.js?body=1',
    %( "xmlhr.js#hash"                                           ) => '/javascripts/xmlhr.js#hash',
    %( "xmlhr.js?123#hash"                                       ) => '/javascripts/xmlhr.js?123#hash',
    %( "xmlhr",             { domain: 'http://www.example.com' } ) => 'http://www.example.com/javascripts/xmlhr.js',
    %( "super/xmlhr",       { domain: 'http://www.example.com' } ) => 'http://www.example.com/javascripts/super/xmlhr.js',
    %( "/super/xmlhr.js",   { domain: 'http://www.example.com' } ) => 'http://www.example.com/super/xmlhr.js',
    %( "xmlhr.min",         { domain: 'http://www.example.com' } ) => 'http://www.example.com/javascripts/xmlhr.min.js',
    %( "xmlhr.min.js",      { domain: 'http://www.example.com' } ) => 'http://www.example.com/javascripts/xmlhr.min.js',
    %( "xmlhr.js?123",      { domain: 'http://www.example.com' } ) => 'http://www.example.com/javascripts/xmlhr.js?123',
    %( "xmlhr.js?body=1",   { domain: 'http://www.example.com' } ) => 'http://www.example.com/javascripts/xmlhr.js?body=1',
    %( "xmlhr.js#hash",     { domain: 'http://www.example.com' } ) => 'http://www.example.com/javascripts/xmlhr.js#hash',
    %( "xmlhr.js?123#hash", { domain: 'http://www.example.com' } ) => 'http://www.example.com/javascripts/xmlhr.js?123#hash'
  }

  def test_javascript_path
    JavascriptPathParams.each do |params, expected|
      assert_js_helper expected, :javascriptPath, params
    end
  end

  JavascriptUrlParams = {
    %( "xmlhr"                                                     ) => 'http://www.example.com/javascripts/xmlhr.js',
    %( "super/xmlhr"                                               ) => 'http://www.example.com/javascripts/super/xmlhr.js',
    %( "/super/xmlhr.js"                                           ) => 'http://www.example.com/super/xmlhr.js',
    %( "xmlhr.min"                                                 ) => 'http://www.example.com/javascripts/xmlhr.min.js',
    %( "xmlhr.min.js"                                              ) => 'http://www.example.com/javascripts/xmlhr.min.js',
    %( "xmlhr.js?123"                                              ) => 'http://www.example.com/javascripts/xmlhr.js?123',
    %( "xmlhr.js?body=1"                                           ) => 'http://www.example.com/javascripts/xmlhr.js?body=1',
    %( "xmlhr.js#hash"                                             ) => 'http://www.example.com/javascripts/xmlhr.js#hash',
    %( "xmlhr.js?123#hash"                                         ) => 'http://www.example.com/javascripts/xmlhr.js?123#hash',
    %( "xmlhr",             { domain: 'http://other.example.com' } ) => 'http://other.example.com/javascripts/xmlhr.js',
    %( "super/xmlhr",       { domain: 'http://other.example.com' } ) => 'http://other.example.com/javascripts/super/xmlhr.js',
    %( "/super/xmlhr.js",   { domain: 'http://other.example.com' } ) => 'http://other.example.com/super/xmlhr.js',
    %( "xmlhr.min",         { domain: 'http://other.example.com' } ) => 'http://other.example.com/javascripts/xmlhr.min.js',
    %( "xmlhr.min.js",      { domain: 'http://other.example.com' } ) => 'http://other.example.com/javascripts/xmlhr.min.js',
    %( "xmlhr.js?123",      { domain: 'http://other.example.com' } ) => 'http://other.example.com/javascripts/xmlhr.js?123',
    %( "xmlhr.js?body=1",   { domain: 'http://other.example.com' } ) => 'http://other.example.com/javascripts/xmlhr.js?body=1',
    %( "xmlhr.js#hash",     { domain: 'http://other.example.com' } ) => 'http://other.example.com/javascripts/xmlhr.js#hash',
    %( "xmlhr.js?123#hash", { domain: 'http://other.example.com' } ) => 'http://other.example.com/javascripts/xmlhr.js?123#hash'
  }

  def test_javascript_url
    JavascriptUrlParams.each do |params, expected|
      assert_js_helper expected, :javascriptUrl, params
    end
  end

  StylesheetPathParams = {
    %( 'bank'                                                     ) => '/stylesheets/bank.css',
    %( 'bank.css'                                                 ) => '/stylesheets/bank.css',
    %( 'subdir/subdir'                                            ) => '/stylesheets/subdir/subdir.css',
    %( '/subdir/subdir.css'                                       ) => '/subdir/subdir.css',
    %( 'style.min'                                                ) => '/stylesheets/style.min.css',
    %( 'style.min.css'                                            ) => '/stylesheets/style.min.css',
    %( 'bank',               { domain: 'http://www.example.com' } ) => 'http://www.example.com/stylesheets/bank.css',
    %( 'bank.css',           { domain: 'http://www.example.com' } ) => 'http://www.example.com/stylesheets/bank.css',
    %( 'subdir/subdir',      { domain: 'http://www.example.com' } ) => 'http://www.example.com/stylesheets/subdir/subdir.css',
    %( '/subdir/subdir.css', { domain: 'http://www.example.com' } ) => 'http://www.example.com/subdir/subdir.css',
    %( 'style.min',          { domain: 'http://www.example.com' } ) => 'http://www.example.com/stylesheets/style.min.css',
    %( 'style.min.css',      { domain: 'http://www.example.com' } ) => 'http://www.example.com/stylesheets/style.min.css'
  }

  def test_stylesheet_path
    StylesheetPathParams.each do |params, expected|
      assert_js_helper expected, :stylesheetPath, params
    end
  end

  StylesheetUrlParams = {
    %( 'bank'                                                       ) => 'http://www.example.com/stylesheets/bank.css',
    %( 'bank.css'                                                   ) => 'http://www.example.com/stylesheets/bank.css',
    %( 'subdir/subdir'                                              ) => 'http://www.example.com/stylesheets/subdir/subdir.css',
    %( '/subdir/subdir.css'                                         ) => 'http://www.example.com/subdir/subdir.css',
    %( 'style.min'                                                  ) => 'http://www.example.com/stylesheets/style.min.css',
    %( 'style.min.css'                                              ) => 'http://www.example.com/stylesheets/style.min.css',
    %( 'bank',               { domain: 'http://other.example.com' } ) => 'http://other.example.com/stylesheets/bank.css',
    %( 'bank.css',           { domain: 'http://other.example.com' } ) => 'http://other.example.com/stylesheets/bank.css',
    %( 'subdir/subdir',      { domain: 'http://other.example.com' } ) => 'http://other.example.com/stylesheets/subdir/subdir.css',
    %( '/subdir/subdir.css', { domain: 'http://other.example.com' } ) => 'http://other.example.com/subdir/subdir.css',
    %( 'style.min',          { domain: 'http://other.example.com' } ) => 'http://other.example.com/stylesheets/style.min.css',
    %( 'style.min.css',      { domain: 'http://other.example.com' } ) => 'http://other.example.com/stylesheets/style.min.css'
  }

  def test_stylesheet_url
    StylesheetUrlParams.each do |params, expected|
      assert_js_helper expected, :stylesheetUrl, params
    end
  end

  VideoPathParams = {
    %( 'xml'                                                ) => '/videos/xml',
    %( 'xml.ogg'                                            ) => '/videos/xml.ogg',
    %( 'dir/xml.ogg'                                        ) => '/videos/dir/xml.ogg',
    %( '/dir/xml.ogg'                                       ) => '/dir/xml.ogg',
    %( 'xml',          { domain: 'http://www.example.com' } ) => 'http://www.example.com/videos/xml',
    %( 'xml.ogg',      { domain: 'http://www.example.com' } ) => 'http://www.example.com/videos/xml.ogg',
    %( 'dir/xml.ogg',  { domain: 'http://www.example.com' } ) => 'http://www.example.com/videos/dir/xml.ogg',
    %( '/dir/xml.ogg', { domain: 'http://www.example.com' } ) => 'http://www.example.com/dir/xml.ogg'
  }

  def test_video_path
    VideoPathParams.each do |params, expected|
      assert_js_helper expected, :videoPath, params
    end
  end

  VideoUrlParams = {
    %( 'xml'                                                  ) => 'http://www.example.com/videos/xml',
    %( 'xml.ogg'                                              ) => 'http://www.example.com/videos/xml.ogg',
    %( 'dir/xml.ogg'                                          ) => 'http://www.example.com/videos/dir/xml.ogg',
    %( '/dir/xml.ogg'                                         ) => 'http://www.example.com/dir/xml.ogg',
    %( 'xml',          { domain: 'http://other.example.com' } ) => 'http://other.example.com/videos/xml',
    %( 'xml.ogg',      { domain: 'http://other.example.com' } ) => 'http://other.example.com/videos/xml.ogg',
    %( 'dir/xml.ogg',  { domain: 'http://other.example.com' } ) => 'http://other.example.com/videos/dir/xml.ogg',
    %( '/dir/xml.ogg', { domain: 'http://other.example.com' } ) => 'http://other.example.com/dir/xml.ogg'
  }

  def test_video_url
    VideoUrlParams.each do |params, expected|
      assert_js_helper expected, :videoUrl, params
    end
  end

end
