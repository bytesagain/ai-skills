#!/usr/bin/env python3
"""Generate content ideas for TikTok."""
import json
import os
import uuid
import argparse
from datetime import datetime

TIKTOK_DIR = os.path.expanduser("~/.openclaw/workspace/memory/tiktok")
IDEAS_FILE = os.path.join(TIKTOK_DIR, "ideas.json")

def ensure_dir():
    os.makedirs(TIKTOK_DIR, exist_ok=True)

def load_ideas():
    if os.path.exists(IDEAS_FILE):
        with open(IDEAS_FILE, 'r') as f:
            return json.load(f)
    return {"ideas": []}

def save_ideas(data):
    ensure_dir()
    with open(IDEAS_FILE, 'w') as f:
        json.dump(data, f, indent=2)

def generate_idea(niche, angle):
    """Generate a platform-native idea with hook angle."""
    templates = {
        "finance": [
            {"concept": "The $5 latte myth debunked", "hook": "Stop blaming coffee for your financial problems"},
            {"concept": "Emergency fund mistakes", "hook": "Your emergency fund is probably wrong"},
        ],
        "fitness": [
            {"concept": "Why cardio won't get you lean", "hook": "I stopped doing cardio and got shredded"},
            {"concept": "Protein timing myth", "hook": "The anabolic window is a lie"},
        ],
        "productivity": [
            {"concept": "To-do lists don't work", "hook": "I haven't used a to-do list in 3 years"},
            {"concept": "Morning routine reality", "hook": "Your morning routine is wasting your time"},
        ]
    }
    
    niche_ideas = templates.get(niche, [
        {"concept": f"{niche} truth nobody talks about", "hook": f"The {niche} industry doesn't want you to know this"}
    ])
    
    import random
    return random.choice(niche_ideas)

def main():
    parser = argparse.ArgumentParser(description='Generate TikTok content ideas')
    parser.add_argument('--niche', required=True, help='Content niche/topic')
    parser.add_argument('--count', type=int, default=3, help='Number of ideas')
    
    args = parser.parse_args()
    
    print(f"\n🎬 CONTENT IDEAS: {args.niche}")
    print("=" * 60)
    
    data = load_ideas()
    
    for i in range(args.count):
        idea = generate_idea(args.niche, None)
        idea_id = f"IDEA-{str(uuid.uuid4())[:6].upper()}"
        
        idea_data = {
            "id": idea_id,
            "niche": args.niche,
            "concept": idea["concept"],
            "hook": idea["hook"],
            "created_at": datetime.now().isoformat(),
            "status": "idea"
        }
        
        data['ideas'].append(idea_data)
        
        print(f"\n{i+1}. {idea['concept']}")
        print(f"   Hook: \"{idea['hook']}\"")
        print(f"   ID: {idea_id}")
    
    save_ideas(data)
    
    print(f"\n✓ {args.count} ideas saved to memory")

if __name__ == '__main__':
    main()
