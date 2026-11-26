# Computer Vision
tier: 2 | sources: ONNX Runtime docs, COCO dataset format spec, OWASP File Upload Cheat Sheet | updated: 2026-11-26
## Triggers
- Image or video input: classification, detection, segmentation, OCR, quality checks, camera features.
- Not for general training and serving (ml role) or hosted LLM vision calls (ai-llm role).
## Responsibilities
- Architecture: task type, model, where inference runs (browser, device, server), latency and cost per image.
- Build: preprocessing, inference wrapper, result schema, upload handling.
- Verify: accuracy on a held-out set that looks like real input.
## Role-specific rules
1. **Define the metric first** (accuracy, mAP, character error rate) and the minimum score that ships.
2. **Try a pretrained model before training.** Fine-tune only if it misses the target on my own sample.
3. **Check dataset and model licenses.** Some weights, including some YOLO versions, restrict commercial use (uncertain).
4. **Test on real conditions:** phone photos, bad light, blur, rotation. Never score on training images.
5. **Where to run:** browser or device for privacy, offline use and zero server cost; server for large models. Record the measured latency at G2.
6. **Export to ONNX or a mobile format** and test the exported model, not only the original.
7. **Preprocess identically** at training and inference (size, color order, normalization). Silent accuracy loss usually comes from here.
8. **Show confidence and allow a manual fix** for OCR and detection. Never auto-act on a low-confidence result.
9. **Images are personal data:** strip EXIF location, set retention, no face recognition without my written scope. Real user images are gate G3 (SKILL.md 2).
## Default tool options
- Detection and classification: pretrained torchvision, MobileNet or YOLO (check license), run through ONNX Runtime.
- OCR: Tesseract (has Bengali data), EasyOCR, PaddleOCR; compare on 20 of my own images.
- Browser inference: ONNX Runtime Web, TensorFlow.js, MediaPipe.
- Free GPU for experiments: Colab or Kaggle free tier. Creating the account is G3.
## Checklist
- [ ] Metric and ship threshold written
- [ ] Held-out real-condition set, score recorded
- [ ] Model and dataset licenses noted
- [ ] Latency per image measured on the target device
- [ ] Exported model outputs match the original
## Common mistakes
- Trusting a benchmark score → measure on my images.
- Resizing differently in production → share one preprocessing function.
- Large model on a free server → quantize or run on the client.
## Definition of done
The real-condition score meets the threshold, latency is measured on the target, licenses are recorded, and a test image runs end to end from upload to result.
## Per-stack notes
- Python/FastAPI: load the model once at startup, not per request.
- Browser/React: run inference in a Web Worker so the UI stays responsive.
- Flutter/React Native: prefer on-device ONNX or TFLite for camera features (package choice uncertain).
