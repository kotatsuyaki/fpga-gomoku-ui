#include <VTop.h>
#include <VTop_Top.h>

#include <SDL2/SDL.h>
#include <SDL2/SDL_pixels.h>
#include <SDL2/SDL_render.h>
#include <SDL2/SDL_video.h>

#include <array>
#include <cstdint>
#include <iostream>
#include <memory>

struct Pixel {
    uint8_t a;
    uint8_t b;
    uint8_t g;
    uint8_t r;
};

static_assert(sizeof(Pixel) == 4, "size of pixel should be 4");
const size_t width = 640;
const size_t height = 480;

int main() {
    /* Module setup */
    auto ctx = std::make_unique<VerilatedContext>();
    ctx->traceEverOn(true);
    auto top = std::make_unique<VTop>(ctx.get(), "Top");

    /* Sdl setup */
    assert(SDL_Init(SDL_INIT_VIDEO) == 0);
    std::array<Pixel, width * height> screen_buf{};

    auto window =
        SDL_CreateWindow("Top", SDL_WINDOWPOS_CENTERED_DISPLAY(1),
                         SDL_WINDOWPOS_CENTERED_DISPLAY(1), width, height,
                         SDL_WINDOW_SHOWN | SDL_WINDOW_UTILITY);
    assert(window);
    auto renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    assert(renderer);
    auto texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888,
                                     SDL_TEXTUREACCESS_TARGET, width, height);
    assert(texture);

    top->rst = 1;
    top->clk = 0;
    ctx->timeInc(1);
    top->eval();

    top->clk = 1;
    ctx->timeInc(1);
    top->eval();

    top->rst = 0;

    auto last_vsync = top->vsync;

    for (int i = 0; i < 100000000; i += 1) {
        if (i == 10000000) {
            top->raw_down = 1;
        } else if (i == 20000000) {
            top->raw_down = 0;
        } else if (i == 30000000) {
            top->raw_center = 1;
        } else if (i == 40000000) {
            top->raw_center = 0;
        } else if (i == 50000000) {
            top->raw_right = 1;
        } else if (i == 60000000) {
            top->raw_right = 0;
        } else if (i == 70000000) {
            top->raw_center = 1;
        } else if (i == 80000000) {
            top->raw_center = 0;
        }

        top->clk = 0;
        ctx->timeInc(1);
        top->eval();

        top->clk = 1;
        ctx->timeInc(1);
        top->eval();

        if (top->Top->h_cnt >= 0 && top->Top->h_cnt < width &&
            top->Top->v_cnt >= 0 && top->Top->v_cnt < height &&
            top->Top->valid) {
            auto& pixel = screen_buf[top->Top->v_cnt * width + top->Top->h_cnt];
            pixel.a = 0xff;
            pixel.r = (top->vga_red & 0b1111) * 16;
            pixel.g = (top->vga_grn & 0b1111) * 16;
            pixel.b = (top->vga_blu & 0b1111) * 16;
        }

        if (last_vsync && !top->vsync) {
            // flush screen
            SDL_Event e;
            if (SDL_PollEvent(&e) && e.type == SDL_QUIT) {
                break;
            }

            assert(SDL_UpdateTexture(texture, nullptr, screen_buf.data(),
                                     sizeof(Pixel) * width) == 0);
            assert(SDL_RenderClear(renderer) == 0);
            assert(SDL_RenderCopy(renderer, texture, nullptr, nullptr) == 0);
            SDL_RenderPresent(renderer);
        }
        last_vsync = top->vsync;
    }

    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return EXIT_SUCCESS;
}
