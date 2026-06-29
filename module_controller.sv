module controller(

    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic last,
    input  logic do_add,

    output logic load,
    output logic add_en,
    output logic shift,
    output logic count_en,
    output logic clear,
    output logic done
);

typedef enum logic [2:0]
{
    IDLE,
    LOAD,
    CHECK,
    ADD,
    SHIFT,
    DONE
} state_t;

state_t state,next_state;

always_ff @(posedge clk or posedge rst) begin

    if(rst)
        state <= IDLE;
    else
        state <= next_state;

end


always_comb begin

    load = 0;
    add_en = 0;
    shift = 0;
    count_en = 0;
    clear = 0;
    done = 0;

    next_state = state;

    case(state)

    IDLE:
    begin
        if(start)
            next_state = LOAD;
    end

    LOAD:
    begin
        load = 1;
        clear = 1;
        next_state = CHECK;
    end

    CHECK:
    begin
        if(do_add)
            next_state = ADD;
        else
            next_state = SHIFT;
    end

    ADD:
    begin
        add_en = 1;
        next_state = SHIFT;
    end

    SHIFT:
    begin
        shift = 1;
        count_en = 1;

        if(last)
            next_state = DONE;
        else
            next_state = CHECK;
    end

    DONE:
    begin
        done = 1;
        next_state = IDLE;
    end

    endcase

end

endmodule
