#!/bin/bash
# D3.js - Data-Driven Documents Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              D3.JS REFERENCE                                ║
║          Data-Driven Documents for the Web                  ║
╚══════════════════════════════════════════════════════════════╝

D3.js is a JavaScript library for manipulating documents based
on data. It binds data to the DOM and applies data-driven
transformations — the building block for custom visualizations.

KEY CONCEPTS:
  Selections    Select DOM elements (like jQuery, but for data)
  Data binding  Bind arrays to DOM elements
  Enter/Update/Exit  Handle new, existing, removed data
  Scales        Map data values to visual values
  Axes          Generate axis components from scales
  Shapes        Lines, arcs, areas, curves
  Transitions   Animate changes smoothly
  Layouts       Force, tree, pack, chord, sankey

D3 vs CHART.JS vs ECHARTS:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ D3.js    │ Chart.js │ ECharts  │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Level        │ Low      │ High     │ High     │
  │ Customization│ Unlimited│ Limited  │ High     │
  │ Learning     │ Hard     │ Easy     │ Medium   │
  │ Charts       │ Anything │ ~8 types │ ~20 types│
  │ Rendering    │ SVG/Canvas│ Canvas  │ Canvas   │
  │ Bundle size  │ Modular  │ ~70KB   │ ~300KB   │
  │ Maps         │ Yes      │ Plugin   │ Built-in │
  │ Animation    │ Full     │ Built-in │ Built-in │
  └──────────────┴──────────┴──────────┴──────────┘

  D3 is a toolkit, not a chart library.
  Use D3 when you need something no chart library can do.

VERSION:
  D3 v7 (current) is fully ESM.
  import * as d3 from "d3";
  // Or individual modules:
  import { select, scaleLinear, axisBottom } from "d3";
EOF
}

cmd_bindscale() {
cat << 'EOF'
DATA BINDING & SCALES
=======================

SELECTIONS:
  d3.select("body")              // First match
  d3.selectAll("circle")         // All matches
  d3.select("#chart")            // By ID
  d3.select(".bar")              // By class

  // Chaining
  d3.select("svg")
    .attr("width", 800)
    .attr("height", 400)
    .style("background", "#111");

DATA JOIN (Enter/Update/Exit):
  const data = [10, 20, 30, 40, 50];

  // The D3 pattern:
  const bars = d3.select("svg")
    .selectAll("rect")
    .data(data);

  // ENTER: new elements
  bars.enter()
    .append("rect")
    .attr("x", (d, i) => i * 50)
    .attr("y", d => 400 - d * 5)
    .attr("width", 40)
    .attr("height", d => d * 5)
    .attr("fill", "steelblue");

  // UPDATE: existing elements
  bars.attr("height", d => d * 5);

  // EXIT: removed elements
  bars.exit().remove();

  // Modern join() (D3 v5+):
  d3.select("svg")
    .selectAll("rect")
    .data(data)
    .join("rect")
    .attr("x", (d, i) => i * 50)
    .attr("y", d => 400 - d * 5)
    .attr("width", 40)
    .attr("height", d => d * 5)
    .attr("fill", "steelblue");

SCALES:
  // Linear scale (continuous → continuous)
  const x = d3.scaleLinear()
    .domain([0, 100])        // Data range
    .range([0, 800]);        // Pixel range
  x(50) // → 400

  // Band scale (categorical → continuous)
  const x = d3.scaleBand()
    .domain(["A", "B", "C", "D"])
    .range([0, 800])
    .padding(0.1);
  x("B")          // → bar position
  x.bandwidth()   // → bar width

  // Time scale
  const x = d3.scaleTime()
    .domain([new Date("2026-01-01"), new Date("2026-12-31")])
    .range([0, 800]);

  // Log scale
  const y = d3.scaleLog().domain([1, 1000000]).range([400, 0]);

  // Color scales
  const color = d3.scaleOrdinal(d3.schemeCategory10);
  const heat = d3.scaleSequential(d3.interpolateViridis).domain([0, 100]);

AXES:
  const xAxis = d3.axisBottom(x).ticks(10).tickFormat(d3.format(".0s"));
  const yAxis = d3.axisLeft(y).ticks(5);

  svg.append("g")
    .attr("transform", `translate(0, ${height - margin.bottom})`)
    .call(xAxis);

  svg.append("g")
    .attr("transform", `translate(${margin.left}, 0)`)
    .call(yAxis);
EOF
}

cmd_shapes() {
cat << 'EOF'
SHAPES & LAYOUTS
==================

LINE CHART:
  const line = d3.line()
    .x(d => x(d.date))
    .y(d => y(d.value))
    .curve(d3.curveMonotoneX);  // Smooth curve

  svg.append("path")
    .datum(data)
    .attr("d", line)
    .attr("fill", "none")
    .attr("stroke", "steelblue")
    .attr("stroke-width", 2);

AREA CHART:
  const area = d3.area()
    .x(d => x(d.date))
    .y0(height)
    .y1(d => y(d.value));

  svg.append("path")
    .datum(data)
    .attr("d", area)
    .attr("fill", "steelblue")
    .attr("opacity", 0.3);

PIE/DONUT:
  const pie = d3.pie().value(d => d.value);
  const arc = d3.arc().innerRadius(50).outerRadius(150);

  svg.selectAll("path")
    .data(pie(data))
    .join("path")
    .attr("d", arc)
    .attr("fill", (d, i) => d3.schemeCategory10[i])
    .attr("transform", `translate(${width/2}, ${height/2})`);

FORCE LAYOUT (network graph):
  const simulation = d3.forceSimulation(nodes)
    .force("link", d3.forceLink(links).id(d => d.id).distance(100))
    .force("charge", d3.forceManyBody().strength(-200))
    .force("center", d3.forceCenter(width/2, height/2))
    .on("tick", () => {
      linkElements.attr("x1", d => d.source.x).attr("y1", d => d.source.y)
                   .attr("x2", d => d.target.x).attr("y2", d => d.target.y);
      nodeElements.attr("cx", d => d.x).attr("cy", d => d.y);
    });

TREEMAP:
  const treemap = d3.treemap()
    .size([width, height])
    .padding(1);

  const root = d3.hierarchy(data).sum(d => d.value);
  treemap(root);

  svg.selectAll("rect")
    .data(root.leaves())
    .join("rect")
    .attr("x", d => d.x0).attr("y", d => d.y0)
    .attr("width", d => d.x1 - d.x0)
    .attr("height", d => d.y1 - d.y0)
    .attr("fill", d => color(d.parent.data.name));

GEO/MAP:
  const projection = d3.geoMercator().fitSize([width, height], geojson);
  const path = d3.geoPath().projection(projection);

  svg.selectAll("path")
    .data(geojson.features)
    .join("path")
    .attr("d", path)
    .attr("fill", d => color(d.properties.value))
    .attr("stroke", "#333");
EOF
}

cmd_transitions() {
cat << 'EOF'
TRANSITIONS & INTERACTIONS
============================

BASIC TRANSITION:
  d3.selectAll("rect")
    .transition()
    .duration(750)
    .ease(d3.easeCubicOut)
    .attr("height", d => y(d.value))
    .attr("fill", "steelblue");

CHAINED TRANSITIONS:
  d3.selectAll("circle")
    .transition().duration(500)
    .attr("r", 20)
    .transition().duration(500)
    .attr("fill", "red")
    .transition().duration(500)
    .attr("r", 5);

EASING FUNCTIONS:
  d3.easeLinear        // Constant speed
  d3.easeQuadIn        // Slow start
  d3.easeQuadOut       // Slow end
  d3.easeCubicInOut    // Slow start and end
  d3.easeBounce        // Bounce effect
  d3.easeElastic       // Spring effect
  d3.easeBack          // Overshoot

EVENT HANDLERS:
  svg.selectAll("rect")
    .on("mouseover", function(event, d) {
      d3.select(this).attr("fill", "orange");
      tooltip.style("display", "block")
        .html(`Value: ${d.value}`)
        .style("left", `${event.pageX + 10}px`)
        .style("top", `${event.pageY - 10}px`);
    })
    .on("mouseout", function() {
      d3.select(this).attr("fill", "steelblue");
      tooltip.style("display", "none");
    })
    .on("click", function(event, d) {
      console.log("Clicked:", d);
    });

ZOOM & PAN:
  const zoom = d3.zoom()
    .scaleExtent([1, 10])
    .on("zoom", (event) => {
      g.attr("transform", event.transform);
    });

  svg.call(zoom);

BRUSH (selection):
  const brush = d3.brushX()
    .extent([[0, 0], [width, height]])
    .on("end", (event) => {
      if (!event.selection) return;
      const [x0, x1] = event.selection.map(x.invert);
      console.log(`Selected range: ${x0} to ${x1}`);
    });

  svg.append("g").call(brush);

DRAG:
  const drag = d3.drag()
    .on("start", (event, d) => { d.fx = d.x; d.fy = d.y; })
    .on("drag", (event, d) => { d.fx = event.x; d.fy = event.y; })
    .on("end", (event, d) => { d.fx = null; d.fy = null; });

  nodes.call(drag);

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
D3.js - Data-Driven Documents Reference

Commands:
  intro        Overview, comparison, concepts
  bindscale    Data binding, scales, axes
  shapes       Line, area, pie, force, treemap, geo
  transitions  Animation, events, zoom, brush, drag

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)       cmd_intro ;;
  bindscale)   cmd_bindscale ;;
  shapes)      cmd_shapes ;;
  transitions) cmd_transitions ;;
  help|*)      show_help ;;
esac
