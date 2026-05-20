# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

# install custom nodes into comfyui
RUN comfy node install --exit-on-fail comfyui_layerstyle@1.0.90 --mode remote || (echo "WARN: comfyui_layerstyle@1.0.90 unavailable in registry, falling back to latest" >&2 && comfy node install --exit-on-fail comfyui_layerstyle --mode remote)
RUN git clone https://github.com/cubiq/ComfyUI_essentials /comfyui/custom_nodes/ComfyUI_essentials && cd /comfyui/custom_nodes/ComfyUI_essentials && (git checkout 9d9f4bedfc9f0321c19faf71855e228c93bd0dc9 2>/dev/null || (git fetch origin 9d9f4bedfc9f0321c19faf71855e228c93bd0dc9 --depth=1 && git checkout 9d9f4bedfc9f0321c19faf71855e228c93bd0dc9) || echo "WARN: commit 9d9f4bedfc9f0321c19faf71855e228c93bd0dc9 unreachable in https://github.com/cubiq/ComfyUI_essentials, falling back to default branch HEAD")
RUN git clone https://github.com/rgthree/rgthree-comfy /comfyui/custom_nodes/rgthree-comfy && cd /comfyui/custom_nodes/rgthree-comfy && (git checkout 683836c46e898668936c433502504cc0627482c5 2>/dev/null || (git fetch origin 683836c46e898668936c433502504cc0627482c5 --depth=1 && git checkout 683836c46e898668936c433502504cc0627482c5) || echo "WARN: commit 683836c46e898668936c433502504cc0627482c5 unreachable in https://github.com/rgthree/rgthree-comfy, falling back to default branch HEAD")
RUN comfy node install --exit-on-fail was-ns@3.0.1 || (echo "WARN: was-ns@3.0.1 unavailable in registry, falling back to latest" >&2 && comfy node install --exit-on-fail was-ns)

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/

# user-provided inputs override the auto-generated placeholders above.
RUN wget --progress=dot:giga -O '/comfyui/input/ComfyUI_00122_.png' "https://cool-anteater-319.convex.cloud/api/storage/1dc2daad-177a-427a-badf-10138787fdd6"
