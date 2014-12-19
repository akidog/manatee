require_relative '../test_helper'

class TagTest < JavascriptRenderer::ViewTest

  def test_simple_tag
    assert_dom_helper '<simple />', :tag, 'simple'
  end

  def test_simple_with_attributes
    assert_dom_helper "<attributed attribute='lorem' data-attribute='this is a data attribute' booleantrue='booleantrue' booleanfalse='false'/>", :tag, 'attributed', attribute: 'lorem', data: { attribute: 'this is a data attribute' }, booleantrue: true, booleanfalse: false
  end

  def test_simple_escapes_attribute
    assert_dom_helper %(<escaped attribute="'escaped' &#34;attribute&#34;"/>), :tag, 'escaped', attribute: %('escaped' "attribute")
  end

  def test_empty_content_tag
    assert_dom_helper '<simple></simple>', :contentTag, 'simple'
  end

  def test_empty_content_with_attributes
    assert_dom_helper "<attributed attribute='lorem' data-attribute='this is a data attribute' booleantrue='booleantrue' booleanfalse='false'></attributed>", :contentTag, 'attributed', attribute: 'lorem', data: { attribute: 'this is a data attribute' }, booleantrue: true, booleanfalse: false
  end

  def test_null_content_tag
    assert_dom_helper '<simple></simple>', :contentTag, 'simple', nil
  end

  def test_null_content_with_attributes
    assert_dom_helper "<attributed attribute='lorem' data-attribute='this is a data attribute' booleantrue='booleantrue' booleanfalse='false'></attributed>", :contentTag, 'attributed', nil, attribute: 'lorem', data: { attribute: 'this is a data attribute' }, booleantrue: true, booleanfalse: false
    assert_dom_helper "<attributed attribute='lorem' data-attribute='this is a data attribute' booleantrue='booleantrue' booleanfalse='false'></attributed>", :contentTag, 'attributed', { attribute: 'lorem', data: { attribute: 'this is a data attribute' }, booleantrue: true, booleanfalse: false }, nil
  end

  def test_block_content_tag
    assert_dom_helper    '<simple>content from block</simple>', :contentTag, 'simple', lambda{ 'content from block' }
    assert_dom_js_helper '<simple>content from function</simple>', :contentTag, %('simple', function(){ return 'content from function'; })
  end

  def test_block_content_with_attributes
    assert_dom_helper    "<attributed attribute='lorem' data-attribute='this is a data attribute' booleantrue='booleantrue' booleanfalse='false'>content from block</attributed>", :contentTag, 'attributed', lambda{ 'content from block' }, attribute: 'lorem', data: { attribute: 'this is a data attribute' }, booleantrue: true, booleanfalse: false
    assert_dom_helper    "<attributed attribute='lorem' data-attribute='this is a data attribute' booleantrue='booleantrue' booleanfalse='false'>content from block</attributed>", :contentTag, 'attributed', { attribute: 'lorem', data: { attribute: 'this is a data attribute' }, booleantrue: true, booleanfalse: false }, lambda{ 'content from block' }
    assert_dom_js_helper "<attributed attribute='lorem' data-attribute='this is a data attribute' booleantrue='booleantrue' booleanfalse='false'>content from function</attributed>", :contentTag, %( 'attributed', function(){ return 'content from function'; }, { attribute: 'lorem', data: { attribute: 'this is a data attribute' }, booleantrue: true, booleanfalse: false } )
    assert_dom_js_helper "<attributed attribute='lorem' data-attribute='this is a data attribute' booleantrue='booleantrue' booleanfalse='false'>content from function</attributed>", :contentTag, %( 'attributed', { attribute: 'lorem', data: { attribute: 'this is a data attribute' }, booleantrue: true, booleanfalse: false }, function(){ return 'content from function'; } )
  end

  def test_content_tag
    assert_dom_helper '<simple>some data</simple>', :contentTag, 'simple', 'some data'
  end

  def test_content_with_attributes
    assert_dom_helper "<attributed attribute='lorem' data-attribute='this is a data attribute' booleantrue='booleantrue' booleanfalse='false'>some data</attributed>", :contentTag, 'attributed', 'some data', attribute: 'lorem', data: { attribute: 'this is a data attribute' }, booleantrue: true, booleanfalse: false
  end

  def test_content_escaped_attribute
    assert_dom_helper %(<escaped attribute="'escaped' &#34;attribute&#34;"></escaped>), :contentTag, 'escaped', attribute: %('escaped' "attribute")
  end

  def test_composing_some_tags
    raw_template = <<-EOT
    this.contentTag('body', { class: 'body_class'}, function(){
      return this.tag('br', { style: 'line-height: 10px' }) +
             this.contentTag('h1', 'Headline', {class: 'main_headline'}) +
             this.tag('hr') +
             this.contentTag('p', 'Once upon a time...');
    })
    EOT
    html_code  = %(<body class="body_class"><br style="line-height: 10px"/><h1 class="main_headline">Headline</h1><hr/><p>Once upon a time...</p></body>)
    assert_dom_template html_code, raw_template
  end

end
