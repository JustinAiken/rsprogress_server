$ ->
  table = $('.dataTable').dataTable
    searching:     true
    processing:    true
    serverSide:    true
    ajax:          $('.dataTable').data('source')
    pagingType:    "full_numbers"
    displayLength: 9999
    lengthMenu:    [100,500,1000,5000,9999]
    stateSave:     false
    bJQueryUI:     true
    bAutoWidth:    false
    order:         [['4', 'asc']]

    fnDrawCallback: (oSettings) ->
      $('.glyphicon-plus, .glyphicon-minus').click (e) ->
        nTr = $(this).parents("tr")[0]
        new RowInfoProcesser(nTr, e).process()

    initComplete: ->
      $("input[id*='filters_arrangement_']").on "change", (e) =>
        th      = $(e.target).closest("th")
        checked = $("input[id*='filters_arrangement_']:checked").map(()->this.value).get()

        table.api().column(th.index()).search(checked).draw()

      $("input[id*='filters_type_']").on "change", (e) =>
        th      = $(e.target).closest("th")
        checked = $("input[id*='filters_type_']:checked").map(()->this.value).get()

        table.api().column(th.index()).search(checked).draw()

      $("input[id*='filters_flag_']").on "change", (e) =>
        th      = $(e.target).closest("th")
        checked = $("input[id*='filters_flag_']:checked").map(()->this.value).get()

        table.api().column(th.index()).search(checked).draw()

    columns: [
      {
        data: '0'
        bSortable: false
        render: (_data, _type, full, _meta) ->
          "<span class='glyphicon glyphicon-plus'  id='a_plus_#{full['DT_RowID']}' style='color: green;'>             </span>" +
          "<span class='glyphicon glyphicon-minus' id='a_hide_#{full['DT_RowID']}' style='color: red; display: none;'></span>"
      }
      { data: "type",   bSortable: false }
      { data: "artist"   }
      { data: "song", className: "dt-nowrap"    }

      { data: "difficulty" }
      { data: "arrangement", bSortable: false }
      { data: "tuning",      bSortable: false }

      { data: "play_count" }
      { data: "mastery" }
      { data: "date_las", className: "dt-nowrap" }

      { data: "sa_play_count" }
      { data: "sa_hard" }
      { data: "sa_master" }
      { data: "date_sa", className: "dt-nowrap" }
      { data: "personal_flag", bSortable: false }
    ]

  class RowInfoProcesser
    constructor: (@nTr, @event) ->

    process: ->
      @get_ap_id()
      @toggle_arrow()

      if @row_is_open()
        @close_row()
      else
        @open_row()

    get_ap_id: ->
      @ap_id = @event.target.id.substr(11,20)

    row_is_open: ->
      table.fnIsOpen(@nTr)

    close_row: =>
      a_note_form = $($(@nTr).next()[0]).children().find("form")[0]
      p_flag_form = $($(@nTr).next()[0]).children().find("form")[1]

      # Post ArrangementNote
      $.ajax(a_note_form.action,
        dataType: "json"
        type:     "POST"
        headers:
          'X-CSRF-Token': $(a_note_form).find("input[name=authenticity_token]").val()
        data:
          arrangement_note:
            body: $(a_note_form).find("textarea[id=arrangement_note_body]").val()
      ).done( =>
        cell_with_note = @nTr.cells[14]
        if $(cell_with_note).html().match("pencil")
          $(cell_with_note).find("span.label.label-info").show()
        else
          $(cell_with_note).append ' <span class="label label-info"> <span class="glyphicon glyphicon-pencil"></span></span>'
      ).fail( =>
        cell_with_note = @nTr.cells[14]
        $(cell_with_note).find("span.label.label-info").hide()
      )

      # Post PersonalFlag
      $.ajax(p_flag_form.action,
        dataType: "json"
        type:     "POST"
        headers:
          'X-CSRF-Token': $(p_flag_form).find("input[name=authenticity_token]").val()
        data:
          personal_flag:
            fc:                $(p_flag_form).find("input[id=personal_flag_fc]").prop "checked"
            "happened_at(1i)": $(p_flag_form).find("select[id=personal_flag_happened_at_1i]").val()
            "happened_at(2i)": $(p_flag_form).find("select[id=personal_flag_happened_at_2i]").val()
            "happened_at(3i)": $(p_flag_form).find("select[id=personal_flag_happened_at_3i]").val()
      ).done( =>
        cell_with_note = @nTr.cells[14]
        if $(cell_with_note).html().match("success")
          $(cell_with_note).find("span.label.label-success").show()
        else
          $(cell_with_note).append ' <span class="label label-success">FC</span>'
      ).fail( =>
        cell_with_note = @nTr.cells[14]
        $(cell_with_note).find("span.label.label-success").hide()
      )

      # And finally close the row:
      table.fnClose @nTr

    open_row: ->
      newRow = table.fnOpen(@nTr, "loading...")
      newRow.className = @new_row_class()
      @load_row(newRow)

    load_row: (newRow) ->
      $.ajax @url(),
        type: 'GET'
        dataType: 'html'
        error: (jqXHR, textStatus, errorThrown) ->
          $('body').append "AJAX Error: #{textStatus}"
        success: (data, textStatus, jqXHR) ->
          $('td', newRow).html(data)
          $('td', newRow).attr( "colspan", '15' )

    url: () ->
      ('/arrangement_progresses/' + @ap_id)

    new_row_class: ->
      @nTr.className

    toggle_arrow: ->
      $("#a_plus_row_" + @ap_id).toggle()
      $("#a_hide_row_" + @ap_id).toggle()
