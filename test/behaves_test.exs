defmodule BehavesTest do
  use ExUnit.Case

  @not_module_atoms [NotAModule, :atom, true, false, nil]

  setup_all do
    Code.compile_file("./test_environment.exs", __DIR__)

    :ok
  end

  describe "like_a?/2" do
    test "returns false when `impl` is not a module" do
      for not_a_module <- @not_module_atoms do
        assert false ==
                 not_a_module
                 |> Behaves.like_a?(BehaviourModule)
      end
    end

    test "returns false when `behaviour` is not a module" do
      for not_a_module <- @not_module_atoms do
        assert false ==
                 ImplModule
                 |> Behaves.like_a?(not_a_module)
      end
    end

    test "returns false when `behaviour` is not a behaviour" do
      assert false ==
               ImplModule
               |> Behaves.like_a?(NotABehaviourModule)
    end

    test "returns false when `impl` does NOT implement `behaviour`" do
      assert false ==
               NotAnImplModule
               |> Behaves.like_a?(BehaviourModule)
    end

    test "returns true `impl` implements `behaviour`" do
      assert true ==
               ImplModule
               |> Behaves.like_a?(BehaviourModule)
    end
  end

  describe "like_a/2" do
    test "informs when `impl` is NOT a module" do
      assert {:not_a_module, NotAModule} =
               NotAModule
               |> Behaves.like_a(BehaviourModule)

      assert {:not_a_module, NotAModule} =
               NotAModule
               |> Behaves.like_a(NotABehaviourModule)
    end

    test "informs when `behaviour` is NOT a module" do
      assert {:not_a_module, NotAModule} =
               ImplModule
               |> Behaves.like_a(NotAModule)
    end

    test "informs when `behaviour` is NOT a behaviour" do
      assert {:not_a_behaviour, NotABehaviourModule} =
               ImplModule
               |> Behaves.like_a(NotABehaviourModule)
    end

    test "informs when `impl` does NOT implement `behaviour`" do
      assert {:not_implemented, {NotAnImplModule, BehaviourModule}} =
               NotAnImplModule
               |> Behaves.like_a(BehaviourModule)
    end

    test "returns :ok when `impl` implements `behaviour`" do
      assert :ok =
               ImplModule
               |> Behaves.like_a(BehaviourModule)
    end
  end

  describe "like_a!/2" do
    test "raise an ArgumentError when `impl` is NOT a module" do
      for not_a_module <- @not_module_atoms do
        assert_raise ArgumentError,
                     "given implementation #{inspect(not_a_module)} is not a module",
                     fn ->
                       not_a_module
                       |> Behaves.like_a!(BehaviourModule)
                     end
      end
    end

    test "raise an ArgumentError when `behaviour` is NOT a module" do
      for not_a_module <- @not_module_atoms do
        assert_raise ArgumentError,
                     "given behaviour #{inspect(not_a_module)} is not a module",
                     fn ->
                       ImplModule
                       |> Behaves.like_a!(not_a_module)
                     end
      end
    end

    test "raise an ArgumentError when `behaviour` is NOT a behaviour" do
      assert_raise ArgumentError,
                   "given behaviour #{inspect(NotABehaviourModule)} is not a behaviour",
                   fn ->
                     ImplModule
                     |> Behaves.like_a!(NotABehaviourModule)
                   end
    end

    test "raise an NotImplementedError when `impl` does NOT implement `behaviour`" do
      assert_raise Behaves.NotImplementedError,
                   "ImplModule does not implement BehaviourWihtoutImplModule",
                   fn ->
                     ImplModule
                     |> Behaves.like_a!(BehaviourWihtoutImplModule)
                   end
    end

    test "returns :ok when `impl` implements `behaviour`" do
      assert :ok =
               ImplModule
               |> Behaves.like_a!(BehaviourModule)
    end
  end

  describe "like_a/1" do
    test "returns its list of behaviours" do
      assert [BehaviourModule, AnotherBehaviourModule] =
               ImplModule
               |> Behaves.like_a()

      assert [] =
               NotAnImplModule
               |> Behaves.like_a()

      assert [] =
               NotAModule
               |> Behaves.like_a()
    end
  end
end
