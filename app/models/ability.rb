class Ability
    include CanCan::Ability

    def initialize(user)
        # Define abilities for the passed in user here. For example:
        #
        #   user ||= User.new # guest user (not logged in)

        if user.has_role? :admin
            can :manage, :all
        elsif user.has_role? :coordinador
            can :read, :all
            alias_action :create, :update, destroy: :cud
            alias_action :create, :update, to: :cu
            can :cu, Dependencia
            can :cu, Departamento
            can :cu, Persona
            can :cu, Conceptopersonal
            can :cu, Cargo
            can :cu, Tipo
            can :cud, Registroconcepto
            can :cud, Familiar
            cannot :read, Setting
        elsif user.has_role? :regular
            can :read, Dependencia
            can :read, Departamento
            can :read, Persona
            can :read, Concepto
            can :read, Conceptopersonal
            can :read, Cargo
            can :read, Tipo
            can :read, Registroconcepto
            can :read, Familiar
            cannot :read, Registro
            cannot :read, Setting

        end
          cannot :read, Dependencia
          cannot :read, Departamento
          cannot :read, Tipo
          cannot :read, Conceptopersonal
        #
        # The first argument to `can` is the action you are giving the user
        # permission to do.
        # If you pass :manage it will apply to every action. Other common actions
        # here are :read, :create, :update and :destroy.
        #
        # The second argument is the resource the user can perform the action on.
        # If you pass :all it will apply to every resource. Otherwise pass a Ruby
        # class of the resource.
        #
        # The third argument is an optional hash of conditions to further filter the
        # objects.
        # For example, here the user can only update published articles.
        #
        #   can :update, Article, :published => true
        #
        # See the wiki for details:
        # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    end
end
