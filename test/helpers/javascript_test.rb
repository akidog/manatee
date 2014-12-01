require_relative '../test_helper'

class JavascriptTest < JavascriptRenderer::ViewTest

  def test_escape_javascript
    assert_helper '', :escapeJavascript, nil

    assert_helper %(This \\"thing\\" is really\\n netos\\'), :escapeJavascript, %(This "thing" is really\n netos')
    assert_helper %(backslash\\\\test),                      :escapeJavascript, %(backslash\\test)
    assert_helper %(dont <\\/close> tags),                   :escapeJavascript, %(dont </close> tags)
    assert_helper %(unicode &#x2028; newline),               :escapeJavascript, %(unicode \342\200\250 newline).force_encoding(Encoding::UTF_8).encode!
    assert_helper %(unicode &#x2029; newline),               :escapeJavascript, %(unicode \342\200\251 newline).force_encoding(Encoding::UTF_8).encode!

    given  = %('quoted' "double-quoted" new-line:\n </closed>)
    expect = %(\\'quoted\\' \\"double-quoted\\" new-line:\\n <\\/closed>)
    assert_helper expect, :escapeJavascript, given

    assert_helper %(dont <\\/close> tags), :j, %(dont </close> tags)
  end

  def test_javascript_tag
    assert_dom_helper "<script>\n//<![CDATA[\nalert('hello')\n//]]>\n</script>", :javascriptTag, "alert('hello')"
  end

  def test_javascript_tag_with_options
    assert_dom_helper "<script id=\"the_js_tag\">\n//<![CDATA[\nalert('hello')\n//]]>\n</script>", :javascriptTag, "alert('hello')", id: "the_js_tag"
  end

  def test_javascript_tag_with_block
    assert_dom_helper "<script>\n//<![CDATA[\nalert('hello')\n//]]>\n</script>",                      :javascriptTag, lambda{ "alert('hello')" }
    assert_dom_helper "<script id=\"js_script_tag\">\n//<![CDATA[\nalert('hello')\n//]]>\n</script>", :javascriptTag, lambda{ "alert('hello')" }, { id: 'js_script_tag' }
    assert_dom_helper "<script id=\"js_script_tag\">\n//<![CDATA[\nalert('hello')\n//]]>\n</script>", :javascriptTag, { id: 'js_script_tag' }, lambda{ "alert('hello')" }

    assert_dom_js_helper "<script>\n//<![CDATA[\nalert('hello')\n//]]>\n</script>",                      :javascriptTag, %(function(){ return "alert('hello')"; })
    assert_dom_js_helper "<script id=\"js_script_tag\">\n//<![CDATA[\nalert('hello')\n//]]>\n</script>", :javascriptTag, %( {id: 'js_script_tag'}, function(){ return "alert('hello')"; } )
    assert_dom_js_helper "<script id=\"js_script_tag\">\n//<![CDATA[\nalert('hello')\n//]]>\n</script>", :javascriptTag, %( function(){ return "alert('hello')"; }, {id: 'js_script_tag'} )
  end

end
