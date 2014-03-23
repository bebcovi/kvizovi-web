jQuery ->

  if $(".pagination").length

    $(window).scroll ->
      url = $(".pagination .next_page a").attr("href")
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 120
        $(".pagination").html $("<p>", class: "text-muted", text: "Učitavanje još kvizova...")
        $.getScript(url)

    $(window).scroll()
