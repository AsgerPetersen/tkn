# encoding: utf-8


orange_bold = "\e[38;5;214;1m"
green = "\e[38;5;118m"
#blue = "\e[38;5;32m"
blue = "\e[38;5;38m"
white = "\e[38;5;15m"
ansi_reset = "\e[0m"


#┌─┬┐  ╔═╦╗  ╓─╥╖  ╒═╤╕
#│ ││  ║ ║║  ║ ║║  │ ││
#├─┼┤  ╠═╬╣  ╟─╫╢  ╞═╪╡
#└─┴┘  ╚═╩╝  ╙─╨╜  ╘═╧╛
#┌───────────────────┐
#│  ╔═══╗ Some Text  │▒
#│  ╚═╦═╝ in the box │▒
#╞═╤══╩══╤═══════════╡▒
#│ ├──┬──┤           │▒
#│ └──┴──┘           │▒
#└───────────────────┘▒
# ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
# ┏━┳┓
# ┣━╋┫
# ┗━┻┛
# ┋┇╏
# ┉┅╍

center <<-EOS
#{orange_bold}GeoCouch: A distributed multidimensional index#{ansi_reset}

#{green}Volker Mische#{ansi_reset}
#{green}@vmx#{ansi_reset}
 #{green}Couchbase#{ansi_reset}

#{blue}FOSS4G 2014-09-12, Portland#{ansi_reset}
EOS

block <<-EOS
#{orange_bold}
                          About me
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━#{ansi_reset}#{white}
- Volker Mische (@vmx)
- Erlang, JavaScript, Rust, Python
- Open Source
- GeoCouch, jslens, MapQuery
- volker@couchbase.com
#{ansi_reset}
EOS

section "Satellite imagery" do
  center <<-EOS
  2D: Polygon
  EOS

  center <<-EOS
  3D: Polygon + Time
  EOS

  center <<-EOS
  4D: Polygon + Time + Direction
  EOS

  center <<-EOS
  5D: Polygon + Time + Direction + Track Number
  EOS
end


section "Couchbase" do
  center <<-EOS
  Distributed in-memory key-value store
  with persistence
  and indexing
  EOS

  center <<-EOS
  Easy operations
  EOS
end

block <<-EOS
#{orange_bold}
             Indexing
━━━━━━━━━━━━━━━━━━━━━#{ansi_reset}#{white}
- TCP
- Eventual
- JavaScript function
  - Mapreduce
  - Spatial
#{ansi_reset}
EOS


section "API" do
  code <<-EOS, :json
  {
      "area": {"type": "Polygon", "coordinates": …},
      "start": "2014-09-12T10:40:21.000Z",
      "end": "2014-09-12T10:40:37.000Z",
      "direction": "asc",
      "track": 124
  }
  EOS

  code <<-EOS, :javascript
  function (doc, meta) {
      emit(/* key */, /* value */);
  }
  EOS

  code <<-EOS, :javascript
  function (doc, meta) {
      emit(doc.area, null);
  }
  EOS

  code <<-EOS, :javascript
  function (doc, meta) {
      var toTimestamp = function(date) {
          return Math.round(
              new Date(date).getTime() / 1000);
      };
      var start = toTimestamp(doc.start);
      var end = toTimestamp(doc.end);
      var key = [doc.area, [start, end]];
      emit(key, null);
  }
  EOS

  code <<-EOS, :javascript
  function (doc, meta) {
      var toTimestamp = function(date) {…};
      var start = toTimestamp(doc.start);
      var end = toTimestamp(doc.end);
      var direction = doc.direction === 'asc' ? 0 : 1;
      var key = [doc.area, [start, end],
          direction, doc.track];
      emit(key, null);
  }
  EOS

#                                        direction
#                                            │
#                   lon     lat     time     │  track
#                    │       │        │      │    │
  block <<-EOS
#{orange_bold}Today's images from Oregon from ascending
satellites only:#{ansi_reset}

?#{white}start_range#{ansi_reset}=[#{blue}116.47#{ansi_reset}, #{blue}42.0#{ansi_reset}, #{blue}1410480000#{ansi_reset}, #{blue}0#{ansi_reset}, #{green}null#{ansi_reset}]
  &#{white}end_range#{ansi_reset}=[#{blue}124.63#{ansi_reset}, #{blue}46.3#{ansi_reset}, #{blue}1410566400#{ansi_reset}, #{blue}0#{ansi_reset}, #{green}null#{ansi_reset}]#{white}
                │       │        │      │    │
               lon     lat     time     │  track
                                    direction
    #{ansi_reset}
  EOS

  code <<-EOS, :json
  {
    "total_rows": 0, "rows": [{
      "id": "demo",
      "key": [
         [117.2, 117.82], [43.1, 44.2],
         [1410518421, 1410518437], [0, 0], [124, 124]],
      "value": null,
      "geometry": {"type": "Polygon", "coordinates": …}
    }, {
      …
    }]
  }
  EOS

  block <<-EOS
#{orange_bold}This year's images of satellite track 124:#{ansi_reset}

?#{white}start_range#{ansi_reset}=[#{green}null#{ansi_reset}, #{green}null#{ansi_reset}, #{blue}1388534400#{ansi_reset}, #{green}null#{ansi_reset}, #{blue}124#{ansi_reset}]
  &#{white}end_range#{ansi_reset}=[#{green}null#{ansi_reset}, #{green}null#{ansi_reset},       #{green}null#{ansi_reset}, #{green}null#{ansi_reset}, #{blue}124#{ansi_reset}]#{white}
                │     │         │       │    │
               lon   lat      time      │  track
                                    direction
    #{ansi_reset}
  EOS

  block <<-EOS

                                 ┣━━━━━━━━━━━━┫
     ┣━━━━━━━━━━━┫
         ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫

            #{green}┣╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┫#{ansi_reset}#{white}
           3pm                      6pm
  EOS
  block <<-EOS
                    #{orange_bold}┣━━━━━━━━┫#{ansi_reset}
  #{white}
                                 ┣━━━━━━━━━━━━┫
     ┣━━━━━━━━━━━┫
         ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫

            #{green}┣╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┫#{ansi_reset}#{white}
           3pm                      6pm
    #{ansi_reset}
  EOS
end


section "Implementation" do
  center <<-EOS
  R-tree
  EOS

  center <<-EOS
  Curse of dimensionality
  EOS

  center <<-EOS
  Performance
  EOS

  block <<-EOS
  #{orange_bold}
           Bulk loading vs. single inserts
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━#{ansi_reset}#{white}
  - Optimal loading is NP-hard
  - Single inserts: tree structure depends
    on insertion order
  - Bulk loading: a priori knowledge
  #{ansi_reset}
  EOS
end

section "Future" do
  center <<-EOS
  Sort-based Query-adaptive Loading of R-trees
  EOS

  block <<-EOS
  #{orange_bold}
        LSM
  ━━━━━━━━━#{ansi_reset}#{white}
  - SQLite4
  - LevelDB
  - RocksDB
  #{ansi_reset}
  EOS
end

center <<-EOS
#{orange_bold}Grab it!#{ansi_reset}

#{green}https://github.com/couchbase/manifest#{ansi_reset}
EOS

center <<-EOS
#{orange_bold}Thanks!#{ansi_reset}

#{green}Volker Mische#{ansi_reset}
#{green}@vmx#{ansi_reset}
 #{green}Couchbase#{ansi_reset}

 #{blue}FOSS4G 2014-09-12, Portland#{ansi_reset}
EOS
