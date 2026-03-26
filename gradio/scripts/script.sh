#!/bin/bash
# Gradio - ML Demo & Web Interface Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              GRADIO REFERENCE                               ║
║          Build ML Demos in Minutes                          ║
╚══════════════════════════════════════════════════════════════╝

Gradio lets you build web UIs for ML models with a few lines
of Python. Demo → share link → anyone can try your model.

KEY FEATURES:
  Quick        3 lines to create a shareable demo
  Share        Public URLs via share=True (tunneling)
  Components   50+ UI components (image, audio, chat, etc.)
  HF Spaces    Free hosting on Hugging Face
  API          Every demo auto-generates REST API
  Streaming    Real-time streaming for LLMs/audio/video
  Blocks       Full layout control for complex apps

GRADIO vs STREAMLIT:
  ┌──────────────┬──────────┬──────────┐
  │ Feature      │ Gradio   │ Streamlit│
  ├──────────────┼──────────┼──────────┤
  │ Best for     │ ML demos │ Data apps│
  │ Sharing      │ 1-click  │ Deploy   │
  │ Input types  │ Rich     │ Basic    │
  │ API          │ Auto     │ No       │
  │ HF Spaces    │ Native   │ Yes      │
  │ Layout       │ Blocks   │ Linear   │
  │ Streaming    │ Native   │ Limited  │
  └──────────────┴──────────┴──────────┘

INSTALL:
  pip install gradio
EOF
}

cmd_basics() {
cat << 'EOF'
BASIC INTERFACES
==================

import gradio as gr

SIMPLEST DEMO (3 lines):
  def greet(name):
      return f"Hello {name}!"

  gr.Interface(fn=greet, inputs="text", outputs="text").launch()

IMAGE CLASSIFIER:
  def classify(image):
      predictions = model.predict(image)
      return {label: float(prob) for label, prob in predictions}

  gr.Interface(
      fn=classify,
      inputs=gr.Image(type="pil"),
      outputs=gr.Label(num_top_classes=5),
      examples=["cat.jpg", "dog.jpg"],
      title="Image Classifier",
      description="Upload an image to classify it.",
  ).launch()

TEXT GENERATION:
  def generate(prompt, temperature, max_tokens):
      return model.generate(prompt, temp=temperature, max=max_tokens)

  gr.Interface(
      fn=generate,
      inputs=[
          gr.Textbox(label="Prompt", lines=3),
          gr.Slider(0, 2, value=0.7, label="Temperature"),
          gr.Slider(50, 500, value=200, label="Max Tokens"),
      ],
      outputs=gr.Textbox(label="Generated Text", lines=5),
  ).launch()

CHATBOT:
  def respond(message, history):
      # history is list of [user_msg, bot_msg]
      response = llm.chat(message, history=history)
      return response

  gr.ChatInterface(
      fn=respond,
      title="AI Chatbot",
      examples=["Hello!", "Explain quantum computing"],
      retry_btn="Retry",
      undo_btn="Undo",
  ).launch()

  # Streaming chatbot
  def stream_respond(message, history):
      partial = ""
      for token in llm.stream(message):
          partial += token
          yield partial

  gr.ChatInterface(fn=stream_respond).launch()

INPUT/OUTPUT TYPES:
  "text"           Textbox
  "image"          Image upload
  "audio"          Audio upload/record
  "video"          Video upload
  "file"           File upload
  "number"         Number input
  "slider"         Slider
  "checkbox"       Boolean
  "dropdown"       Select menu
  "dataframe"      Table input/output
  "label"          Classification output
  "plot"           Matplotlib/Plotly figure
  "json"           JSON viewer
  "html"           HTML output
  "markdown"       Markdown output
  "gallery"        Image gallery
  "3Dmodel"        3D model viewer
  "code"           Code editor
EOF
}

cmd_blocks() {
cat << 'EOF'
BLOCKS API & ADVANCED
=======================

BLOCKS (full layout control):
  import gradio as gr

  with gr.Blocks(theme=gr.themes.Soft()) as demo:
      gr.Markdown("# My App")

      with gr.Row():
          with gr.Column(scale=2):
              input_text = gr.Textbox(label="Input", lines=5)
              with gr.Row():
                  submit_btn = gr.Button("Submit", variant="primary")
                  clear_btn = gr.ClearButton([input_text])
          with gr.Column(scale=1):
              output_text = gr.Textbox(label="Output", lines=5)
              status = gr.Label(label="Status")

      with gr.Accordion("Settings", open=False):
          temperature = gr.Slider(0, 2, value=0.7)
          model_choice = gr.Dropdown(["gpt-4", "claude"], value="gpt-4")

      with gr.Tab("Results"):
          gallery = gr.Gallery()
      with gr.Tab("History"):
          history_df = gr.Dataframe()

      submit_btn.click(
          fn=process,
          inputs=[input_text, temperature, model_choice],
          outputs=[output_text, status],
      )

  demo.launch()

EVENT HANDLERS:
  # Click
  btn.click(fn=process, inputs=[...], outputs=[...])

  # Change (on input change)
  slider.change(fn=update, inputs=[slider], outputs=[output])

  # Submit (on Enter in textbox)
  textbox.submit(fn=process, inputs=[textbox], outputs=[output])

  # Chaining events
  btn.click(fn=step1, inputs=x, outputs=y) \
     .then(fn=step2, inputs=y, outputs=z)

STREAMING:
  def stream_text(prompt):
      for token in llm.stream(prompt):
          yield token

  btn.click(fn=stream_text, inputs=[prompt], outputs=[output])

SHARING & DEPLOYMENT:
  # Public URL (72 hours)
  demo.launch(share=True)

  # Custom server
  demo.launch(server_name="0.0.0.0", server_port=7860)

  # Authentication
  demo.launch(auth=("admin", "password"))
  demo.launch(auth=[(u1, p1), (u2, p2)])

  # Hugging Face Spaces
  # 1. Create Space on huggingface.co
  # 2. Push app.py + requirements.txt
  # 3. Auto-deploys!

  # Docker
  FROM python:3.12-slim
  COPY . /app
  WORKDIR /app
  RUN pip install -r requirements.txt
  EXPOSE 7860
  CMD ["python", "app.py"]

API (auto-generated):
  # Every Gradio app has a REST API
  # Visit http://localhost:7860/api/ for docs

  # Python client
  from gradio_client import Client
  client = Client("http://localhost:7860/")
  result = client.predict("Hello", api_name="/predict")

  # Or from HF Spaces
  client = Client("username/my-space")

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Gradio - ML Demo & Web Interface Reference

Commands:
  intro    Overview, comparison with Streamlit
  basics   Interface, chatbot, streaming, components
  blocks   Blocks layout, events, sharing, API

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)  cmd_intro ;;
  basics) cmd_basics ;;
  blocks) cmd_blocks ;;
  help|*) show_help ;;
esac
