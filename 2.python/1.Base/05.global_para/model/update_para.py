import global_paras

global_paras._init()

def update(var1, var2, var3):
    global_paras.set_value('var1', var1)
    global_paras.set_value('var2', var2)
    global_paras.set_value('var3', var3)
