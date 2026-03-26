#!/bin/bash
# Streamlit - Python Web Apps for Data Science Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              STREAMLIT REFERENCE                            ║
║          Python Web Apps in Minutes                         ║
╚══════════════════════════════════════════════════════════════╝

Streamlit turns Python scripts into interactive web apps. No
frontend knowledge needed — just write Python, and Streamlit
handles the UI.

KEY FEATURES:
  Script → App    Write a .py file, get a web app
  Reactive        Widgets auto-trigger reruns
  Widgets         Sliders, buttons, selects, file upload
  Data display    DataFrames, charts, metrics, maps
  Caching         @st.cache_data for expensive computations
  Session state   Persist data across reruns
  Layouts         Sidebar, columns, tabs, expanders

STREAMLIT vs GRADIO vs DASH:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │Streamlit │ Gradio   │ Dash     │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Learning     │ Easiest  │ Easy     │ Medium   │
  │ Use case     │ Data apps│ ML demos │ Dashboards│
  │ Reactivity   │ Auto     │ Event    │ Callback │
  │ Customization│ Medium   │ Low      │ High     │
  │ Components   │ Many     │ ML focus │ Full HTML│
  │ Deployment   │ Cloud    │ Spaces   │ Self     │
  └──────────────┴──────────┴──────────┴──────────┘

INSTALL:
  pip install streamlit
  streamlit run app.py     # Launch app
EOF
}

cmd_widgets() {
cat << 'EOF'
WIDGETS & INPUT
=================

import streamlit as st

TEXT:
  st.title("My Dashboard")
  st.header("Section 1")
  st.subheader("Subsection")
  st.text("Fixed-width text")
  st.markdown("**Bold** and _italic_")
  st.code("print('hello')", language="python")
  st.latex(r"E = mc^2")
  st.divider()

INPUT WIDGETS:
  name = st.text_input("Your name", value="Alice")
  age = st.number_input("Age", min_value=0, max_value=120, value=25)
  bio = st.text_area("Bio", height=100)
  agree = st.checkbox("I agree")
  option = st.selectbox("Choose", ["A", "B", "C"])
  options = st.multiselect("Choose many", ["X", "Y", "Z"])
  value = st.slider("Value", 0, 100, 50)
  range_val = st.slider("Range", 0.0, 100.0, (25.0, 75.0))
  color = st.color_picker("Color", "#00f900")
  date = st.date_input("Date")
  time = st.time_input("Time")
  file = st.file_uploader("Upload CSV", type=["csv"])
  photo = st.camera_input("Take a photo")

BUTTONS:
  if st.button("Click me"):
      st.write("Clicked!")

  # Download button
  st.download_button("Download CSV", data=csv_string, file_name="data.csv")

FORMS (batch submit):
  with st.form("my_form"):
      name = st.text_input("Name")
      email = st.text_input("Email")
      submitted = st.form_submit_button("Submit")
      if submitted:
          st.success(f"Welcome {name}!")

DATA DISPLAY:
  st.dataframe(df)                    # Interactive table
  st.table(df)                        # Static table
  st.metric("Revenue", "$1.2M", "+12%")
  st.json({"key": "value"})

  # Columns of metrics
  col1, col2, col3 = st.columns(3)
  col1.metric("Users", "1,234", "+5%")
  col2.metric("Revenue", "$45K", "+12%")
  col3.metric("Orders", "567", "-2%")

CHARTS:
  st.line_chart(df)
  st.area_chart(df)
  st.bar_chart(df)
  st.scatter_chart(df, x="col1", y="col2")
  st.map(df)  # Needs lat/lon columns

  # Matplotlib/Plotly/Altair
  fig, ax = plt.subplots()
  ax.plot([1,2,3], [1,4,9])
  st.pyplot(fig)

  st.plotly_chart(plotly_fig)
  st.altair_chart(altair_chart)
EOF
}

cmd_advanced() {
cat << 'EOF'
ADVANCED FEATURES
===================

CACHING:
  @st.cache_data
  def load_data(path):
      return pd.read_csv(path)

  @st.cache_resource
  def init_model():
      return load_ml_model()

  # cache_data: for data (DataFrames, arrays, strings)
  # cache_resource: for global resources (models, DB connections)

  # TTL (time-to-live)
  @st.cache_data(ttl=3600)  # Cache for 1 hour
  def fetch_api_data():
      return requests.get("https://api.example.com/data").json()

SESSION STATE:
  # Persist across reruns
  if "count" not in st.session_state:
      st.session_state.count = 0

  if st.button("Increment"):
      st.session_state.count += 1

  st.write(f"Count: {st.session_state.count}")

  # Widget state
  st.text_input("Name", key="user_name")
  st.write(f"Hello {st.session_state.user_name}")

LAYOUT:
  # Sidebar
  with st.sidebar:
      st.title("Settings")
      option = st.selectbox("Model", ["GPT-4", "Claude"])
      temperature = st.slider("Temperature", 0.0, 2.0, 0.7)

  # Columns
  col1, col2 = st.columns([2, 1])  # 2:1 ratio
  with col1:
      st.write("Main content")
  with col2:
      st.write("Sidebar content")

  # Tabs
  tab1, tab2, tab3 = st.tabs(["Chart", "Data", "Settings"])
  with tab1:
      st.line_chart(data)
  with tab2:
      st.dataframe(df)

  # Expander
  with st.expander("Show details"):
      st.write("Hidden content here")

  # Container
  with st.container(border=True):
      st.write("Bordered section")

STATUS:
  st.success("Done!")
  st.error("Something went wrong")
  st.warning("Be careful")
  st.info("FYI")
  st.toast("Quick notification!")

  with st.spinner("Loading..."):
      time.sleep(2)

  bar = st.progress(0)
  for i in range(100):
      bar.progress(i + 1)

  st.balloons()     # Celebration!
  st.snow()         # Winter!

MULTI-PAGE APP:
  # pages/1_Dashboard.py
  # pages/2_Settings.py
  # pages/3_About.py
  # Streamlit auto-detects pages/ directory

DEPLOYMENT:
  # Streamlit Community Cloud (free)
  # 1. Push to GitHub
  # 2. streamlit.io → New app → Select repo
  # 3. Done!

  # Docker
  FROM python:3.12-slim
  COPY . /app
  WORKDIR /app
  RUN pip install -r requirements.txt
  EXPOSE 8501
  CMD ["streamlit", "run", "app.py", "--server.address=0.0.0.0"]

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Streamlit - Python Web Apps Reference

Commands:
  intro      Overview, comparison
  widgets    Input widgets, data display, charts
  advanced   Caching, session state, layout, deployment

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  widgets)  cmd_widgets ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac
