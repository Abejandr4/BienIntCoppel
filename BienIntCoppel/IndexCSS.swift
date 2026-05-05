//
//  IndexCSS.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Nunito:wght@400;600;700;800&display=swap');

@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --font-heading: 'Nunito', sans-serif;
    --font-body: 'Inter', sans-serif;

    --background: 30 30% 98%;
    --foreground: 220 20% 14%;
    --card: 0 0% 100%;
    --card-foreground: 220 20% 14%;
    --popover: 0 0% 100%;
    --popover-foreground: 220 20% 14%;
    --primary: 25 85% 58%;
    --primary-foreground: 0 0% 100%;
    --secondary: 145 35% 88%;
    --secondary-foreground: 150 30% 25%;
    --muted: 30 20% 94%;
    --muted-foreground: 220 10% 46%;
    --accent: 150 40% 55%;
    --accent-foreground: 0 0% 100%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 0 0% 98%;
    --border: 30 15% 90%;
    --input: 30 15% 88%;
    --ring: 25 85% 58%;
    --chart-1: 25 85% 58%;
    --chart-2: 150 40% 55%;
    --chart-3: 45 80% 60%;
    --chart-4: 200 50% 55%;
    --chart-5: 340 55% 60%;
    --radius: 1rem;
    --sidebar-background: 0 0% 98%;
    --sidebar-foreground: 240 5.3% 26.1%;
    --sidebar-primary: 240 5.9% 10%;
    --sidebar-primary-foreground: 0 0% 98%;
    --sidebar-accent: 240 4.8% 95.9%;
    --sidebar-accent-foreground: 240 5.9% 10%;
    --sidebar-border: 220 13% 91%;
    --sidebar-ring: 217.2 91.2% 59.8%;
  }

  .dark {
    --background: 220 15% 8%;
    --foreground: 30 20% 95%;
    --card: 220 15% 12%;
    --card-foreground: 30 20% 95%;
    --popover: 220 15% 12%;
    --popover-foreground: 30 20% 95%;
    --primary: 25 85% 58%;
    --primary-foreground: 0 0% 100%;
    --secondary: 150 20% 18%;
    --secondary-foreground: 150 30% 85%;
    --muted: 220 12% 16%;
    --muted-foreground: 220 10% 55%;
    --accent: 150 40% 45%;
    --accent-foreground: 0 0% 100%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 0 0% 98%;
    --border: 220 12% 18%;
    --input: 220 12% 18%;
    --ring: 25 85% 58%;
    --chart-1: 25 85% 58%;
    --chart-2: 150 40% 55%;
    --chart-3: 45 80% 60%;
    --chart-4: 200 50% 55%;
    --chart-5: 340 55% 60%;
    --sidebar-background: 220 15% 8%;
    --sidebar-foreground: 240 4.8% 95.9%;
    --sidebar-primary: 224.3 76.3% 48%;
    --sidebar-primary-foreground: 0 0% 100%;
    --sidebar-accent: 240 3.7% 15.9%;
    --sidebar-accent-foreground: 240 4.8% 95.9%;
    --sidebar-border: 240 3.7% 15.9%;
    --sidebar-ring: 217.2 91.2% 59.8%;
  }
}

@layer base {
  * {
    @apply border-border outline-ring/50;
  }
  body {
    @apply bg-background text-foreground;
  }
}
