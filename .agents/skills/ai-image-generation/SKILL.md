# Skill: ai-image-generation

## Overview

A multi-model AI image generation skill pack. Supports text-to-image, image-to-image, LoRA fine-tuning, and more using models such as FLUX, Gemini Imagen, and Grok Aurora.

## Capabilities

- Text-to-image: generate images from natural language prompts
- Image-to-image: transform or refine existing images with a prompt
- Style transfer: apply artistic styles to photos or illustrations
- LoRA: apply fine-tuned model weights for consistent character or style
- Batch generation: produce multiple variants for comparison

## How to Invoke

Tell the AI assistant:

```
Use the ai-image-generation skill to generate [describe what you need].
```

Provide: subject, style, aspect ratio, model preference (optional), and any reference images.

## Supported Models

| Model | Strengths |
|-------|-----------|
| FLUX.1 | Photorealistic, high detail, fast |
| Gemini Imagen | Versatile, good at text rendering |
| Grok Aurora | Creative, stylized output |
| Stable Diffusion XL | Open-source, highly customizable |

## Prompt Guidelines

- Be specific about subject, lighting, composition, and style
- Use negative prompts to exclude unwanted elements
- Specify aspect ratio: `1:1`, `16:9`, `9:16`, `4:3`
- For consistent characters, reference a LoRA weight or seed

## Output

- Image file(s) at requested resolution
- Prompt and generation parameters recorded for reproducibility

## Notes

- API keys for hosted models must be configured in repository secrets
- For open-source models, a GPU environment or Replicate API is recommended
