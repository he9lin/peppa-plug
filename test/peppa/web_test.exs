defmodule WebTest do
  use ExUnit.Case
  use Plug.Test

  alias Peppa.Web

  @opts Web.init([])

  @weixin_cb_payload """
  <xml>
<Encrypt><![CDATA[3kKZ++U5ocvIF8dAHPct7xvUqEv6vplhuzA8Vwj7OnVcBu9fdmbbI41zclSfKqP6/bdYAxuE3x8jse43ImHaV07siJF473TsXhl8Yt8task0n9KC7BDA73mFTwlhYvuCIFnU6wFlzOkHyM5Bh2qpOHYk5nSMRyUG4BwmXpxq8TvLgJV1jj2DXdGW4qdknGLfJgDH5sCPJeBzNC8j8KtrJFxmG7qIwKHn3H5sqBf6UqhXFdbLuTWL3jwE7yMLhzOmiHi/MX/ZsVQ7sMuBiV6bW0wkgielESC3yNUPo4q/RMAFEH0fRLr76BR5Ct0nUbf9PdClc0RdlYcztyOs54X/KLbYRNCQ2kXxmJYL6ekdNe70PCAReIEfXEp+pGpry4ss8bD6LKAtNvBJUwHshZe6sbf+fOiDiuKEqp1wdQLmgN+8nX62LklySWr8QrNCpsmKClxco0kbVYNX/QVh5yd0UA1sAqIn6baZ9G+Z/OXG+Q4n9lUuzLprLhDBPaCvXm4N14oqXNcw7tqU2xfhYNIDaD72djyIc/4eyAi2ZsJ+3hb+jgiISR5WVveRWYYqGZGTW3u+27JiXEo0fs3DQDbGVIcYxaMgU/RRIDdXzZSFcf6Z1azjzCDyV9FFEsicghHn]]></Encrypt>
<MsgSignature><![CDATA[096d8cda45e4678ca23460f6b8cd281b3faf1fc3]]></MsgSignature>
<TimeStamp>1415979516</TimeStamp>
<Nonce><![CDATA[1320562132]]></Nonce>
</xml>
  """

  test "ok" do
    conn = conn(:get, "/")
           |> Web.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "ok"
  end

  test "/weixin_callback" do
    conn = conn(:post, "/weixin_callback", @weixin_cb_payload)
           |> put_req_header("content-type", "text/plain")
           |> Web.call(@opts)

    assert conn.status == 201
    assert conn.resp_body == "success"
  end

  test "/:app_id/callback" do
    conn = conn(:post, "/wx12345/callback", @weixin_cb_payload)
           |> put_req_header("content-type", "text/plain")
           |> Web.call(@opts)

    assert conn.status == 201
    assert conn.resp_body == "success"
  end
end
